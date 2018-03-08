---
author: David Vandorpe
title: 'Cyber Security Challenge 2018: Radium'
created_at: 08/03/2018
toc: true
---

**Category:** Network Security  
**Points:** 150  

**Description:**

Someone implemented a protocol to execute (privileged) commands on a server. After months of analysis, our word-class TAO team didn't find a single buffer overflow.. However, they were able to compromise a router between a communicating client and server.

To perform a man-in-the-middle attack through this router, forward data between 52.210.242.66:8023 (this represents the server) and 52.210.242.66:8024 (this represents the client).

See client.c for an example command to do this. Abuse the resulting man-in-the-middle position to somehow obtain the ability to execute privileged commands!

*Hint*: When is the authenticity of a packet verified? When is the data payload of a packet decrypted?

[Source code](https://zeus.ugent.be/zeuswpi/jaWQQLqU.zip)

## Introduction

This challenge proved to be possibly the hardest challenge, going unsolved until the organisers decided to reveal a hint near the end of the competition. Even then, our team was the only one to solve it.

## Write-up

The zip file contains the code ran on the server and the client. The client and server share a secret password and a secret key. The flow to request the flag is as follow:

* Client sends the randomly generated client nonce to the server
* Server replies with a randomly generated server nonce.
	- The session key (all following communications will use this key) is now `HMAC_SHA256(secret_key, "CSCBE18 Session Key Generation" || client_nonce || server_nonce)`
* The client sends a flag request to the server, which requires a password. Unfortunately this password is encrypted.
* The server responds with the (encrypted) flag

The same routine was also available without encryption if the client didn't pass a NONCE in it's handshake.

So, how do we get our flag? Let's list some ideas:

* Find an attack on the encryption algorithm (AES in OFB mode)
* Try to trick client and server to use the flow without encryption
* Try to set the key to a known value
* Try to trick the server into dumping the flag without a password
* Try to trick the server into using a known encryption key
* Try to generate an error message on the server that includes (a part of) the flag or encryption key
* Try to generate an error message on the client that includes (a part of) the flag or encryption key

Let's see what these ideas lead to.

We found a [writeup](https://github.com/Alpackers/CTF-Writeups/tree/master/2016/BostonKeyParty/Crypto/des-ofb) from another CTF that cracks DES encryption in OFB mode. The key weakness here is using a weak DES key (making encryption symmetric), in combination with OFB. But wait a second, isn't AES a symmetric algorithm? So basically we would expect the second block of ciphertext to just be the plaintext XOR'd with the IV. However, for reasons unknown to me this turned out not to be the case.

Setting the encryption key to NULL on the server seemed easy enough, but sadly this would also mean that the server couldn't decrypt the messages from the client (as this key was used for both encryption and decryption by both sides).

To understand the next step, let's see how the plaintext is formatted. It consists of some header bytes (including IV and HMAC sign) followed by data. The data is the only part that gets encrypted if encryption is used. This data is essentially an array of different data blocks. The first two bytes of each block are the "TlvType" (an enum in `packets.h`) and the length of the data block (excluding these two bytes). The rest of block is the actual data. It is also essential to understand that AES+OFB generates a bytestream which only depends on the IV and the encryption key. This stream does then get XOR'd with the plaintext. Changing a byte in the plain/ciphertext only changes the corresponding byte in the cipher/plaintext. If we know a byte P from the plaintext, it is easy to substitute it with another byte P': simply change C to C'=C XOR P XOR P'.

Let's dive back into the code. When trying to dump the flag through an error message (which never gets encrypted) on the client side, we stumbled across some interesting code.

~~~ c
size_t pos = 0;
while (pos < len && len - pos >= 2)
{
	// Assure there is enough length for the element
	if (data[pos + 1] > len - pos - 2) {
		send_error(session, "%s: not enough data left for element type %d (need %d bytes but only %d left)\n",
			__FUNCTION__, data[pos], data[pos + 1], len - pos - 2);
		return -1;
	}
~~~

This is were our attack will happen. We let the flow described earlier proceed as normal, except we intercept the final message returning the flag to the client. Assume we want to decrypt the fifth byte of the flag. If we manage to set the length of the first datablock to 3, the fifth byte of the flag will be interpreted as the length of the second data block. If this length is greater than the amount of remaining bytes, then our byte will get sent back to the server unencrypted! To do this, we need to know the original length of the flag, which is hardcoded and 39. So we replace the second byte with `C' = C XOR 0x27 XOR 0x3` and this should print the correct byte and the preceding byte.

However, we're not there yet. All ciphertexts get signed with HMAC_SHA256. At this point, we got stuck for a bit. Around 2.5 hours before the competition ended a hint was posted (see challenge description) which led to the solution.

~~~ c
static int radium_check_authenticity(struct radium_session *session, struct pkt_header *hdr)
{
	// Nothing to do if no encryption is used, or if it's not an authenticated message
	if (!session->using_encryption || hdr->msgtype < Packet_Command)
		return 0;
	// We need a session key to verify all the other packets
	else if (!session->using_encryption || !session->handshake_done) {
		fprintf(stderr, "%s: no session key available to check authenticity\n", __FUNCTION__);
		return -1;
	}

static int radium_decrypt_data(struct radium_session *session, struct pkt_header *hdr)
{
	// Nothing to do if not encrypted
	if (!hdr->encrypted)
		return 0;
~~~

Basically, the solution was to set the msgtype byte to 0x1 (ServerHello). This wasn't according to our protocol flow, but that didn't matter as we intended to already produce an error during the parsing of the message. Throwing this together revealed that the fifth byte was 'E', which matched our expectation of flag format "CSCBE{.................................}". Jackpot! Now we just had to repeat for all other bytes. A simple [python script](https://zeus.ugent.be/zeuswpi/GotPD6yg.py) solved this.

Flag: CSCBE{1FFCD19C964D3E5DF5B4CFF490583AC1}
