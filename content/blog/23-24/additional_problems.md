---
title: "Belgian Cyber Security Challenge 2024: Additional problems"
created_at: '2024-03-09'
description: "Solution of the 'Additional problems' cryptography challenge"
author: "Jasper Devreker"
---

**Title**: Additional Problems

**Category**: cryptography

**Points**: 500

**Solves**: 2

**Description**:

Version 1.0 of our new encryption service has just launched!
It is blazingly fast and uses state-of-the-art encryption.
Stay tuned for version 2.0; I hear it will bring tons of improvements and security fixes.

[Download challenge files](http://pics.zeus.gent/server.py)

Access the server via `nc IP_ADDRESS PORT` (the server is now down, but you can run it yourself)

# Introduction

This challenge proved to be among the hardest challenges at CSCBE, with only one team submitting a flag. The teams at Zeus WPI ended up in 2nd, 9th (virtual, since winners are not allowed to participate again), 52nd and 83rd and 104th place at the online qualifiers.

# Description

The challenge provides a Python file, which runs a server accessible through a TCP socket.
The server implements a form of homomorphic encryption: with homomorphic encryption, addition of two ciphertexts results in a ciphertext that decrypts to the addition of the two plaintexts.
Here, the encryption was implemented with a secret 128-bit prime `p`, and an `N` between 128 and 255. The cryptosystem works as follows:

<pre><code>#!python
def dghv_encrypt(p, N, m):
    """
    Encrypt a value to later decrypt with `dghv_decrypt`
    """
    assert 2**7 <= N < 2**8 # Normally this is 2, but by using a bigger `N` we can encode ASCII bytes instead of bits! That's much more efficient. All `N` in this range should be secure, so let's make it an assertion

    q = reduce(lambda x, y: x*y, [Crypto.Util.number.getPrime(128) for _ in range(8)]) # `q` can be any number, but as we all know, big primes are the safest numbers there are
    rmax = 2**128 / N / 4
    r = random.randint(0, rmax) # In v2.0, we will let `r` be negative as well as positive => double the randomness!
    return p*q + N*r + m

def dghv_decrypt(p, N, c):
    """
    Since c = pq + Nr + m, we can find m as (c mod p) mod N!
    """
    return (c % p) % N

def dghv_add(c1, c2):
    """
    The sum of ciphertexts decodes to the sum of plaintexts!!!
    """
    return c1 + c2 # We will add bootstrapping to make this fully homomorphic in v2.0

</code></pre>

Encryption, decryption and adding works on byte-based granularity: every byte is encrypted separately.

When first connecting, the server generates a new `p`, encrypts the flag with it and prints the encrypted flag.
It then asks for an `N` value and a (hexadecimal) plaintext that will be used in your first session.

It then provides a menu where you have three options:

- Start a new session, where you need to give an `N` value and a plaintext; it will use `dghv_encrypt` to set the ciphertext
- Add an additional plaintext to the current session: it will encrypt that plaintext with `dghv_encrypt`, then use `dghv_add` to add it to the current ciphertext
- Decrypt the ciphertext: it returns the result of `dghv_decrypt` on the current ciphertext

Note that other than the initial ciphertext printed at startup, we never have access to any ciphertexts.


# Vulnerability

If you add too many plaintexts, the `N*r` terms become greater than `p`, making the decryption step `(c % p) % N` not work correctly anymore. Suppose you always send zero-filled plaintext, and it eventually decrypts to a value `x != 0`, then we have:

<pre><code>
(p*q + N*r + (m_0 + m_1 + m_... + m_n)) % p % N == x

because all message bytes m_n are 0, we have

(p*q + N*r) % p % N == x

now, let N*r > p, but smaller than 2*p (we can be sure of this,
since r only increases with maximum 2**128 / N / 4 per encryption
and p is a 128 bit prime), then we have

N*r = p + a.

By substituting N*r for p + a

(p*q + p + a) % p % N == x

which is then equal to

a % p % N == x

and thus, since a < p,

a % N = x

and since 0 < x < N,

p % N == N - x.

</code></pre>

We can then iterate through all prime values of N between 128 and 255 to get each value of `p % N_i`; once we have these values, we can use [the Chinese Remainder Theorem](https://en.wikipedia.org/wiki/Chinese_remainder_theorem) to calculate p (since the product of all those primes is bigger than 128 bits, p is uniquely determined).


# Solution script

This script was written in the heat of the moment, so it's not the cleanest, but it works.
It uses the excellent pwntools library.

<pre><code>#!python
from pwn import remote

conn = remote('additional_problems.challenges.cybersecuritychallenge.be', 1340)

def dghv_decrypt(p, N, c):
    """
    Since c = pq + Nr + m, we can find m as (c mod p) mod N!
    """
    return (c % p) % N


def add(conn, msg):
    print('add')
    conn.sendline(b'2')
    conn.sendline(msg)
    conn.recvuntil(b'> ')

def get(conn):
    print('get')
    conn.sendline(b'3')
    lines = conn.recvuntil(b'> ')
    hexed = [int(a, 16) for a in lines.decode().split('\n')[0].split(': ')[1].split(' ')]
    return hexed

def new(conn, N, msg):
    print('new')
    conn.sendline(b'1')
    conn.recvuntil(b'Choose N: ')
    conn.sendline(str(N).encode())
    conn.recvuntil(b'Message to encode (converted to hexadecimal): ')
    conn.sendline(msg)
    conn.recvuntil(b'> ')

conn.recvuntil(b"We've even encrypted our secret flag with it:\n")

encrypted = conn.recvuntil(b'\n\n').decode().strip()

# only in modified testserver
# p, encrypted = encrypted.split('\n', maxsplit=1)
# p = int(p.strip())

ciphertexts = [int(e.strip()) for e in encrypted.split('\n')]

# skip initial setup
conn.sendline(b'128')
conn.recvuntil(b'Message to encode (converted to hexadecimal): ')
conn.sendline((' '.join('00' for _ in range(30))).encode())
conn.recvuntil(b'> ')

# real shit
all_zeroes = (' '.join('00' for _ in range(10))).encode()

primes = [131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251]

mapped = {}


from functools import reduce
def chinese_remainder(m, a):
    sum = 0
    prod = reduce(lambda acc, b: acc*b, m)
    for n_i, a_i in zip(m, a):
        p = prod // n_i
        sum += a_i * mul_inv(p, n_i) * p
    return sum % prod
 
def mul_inv(a, b):
    b0 = b
    x0, x1 = 0, 1
    if b == 1: return 1
    while a > 1:
        q = a // b
        a, b = b, a%b
        x0, x1 = x1 - q * x0, x0
    if x1 < 0: x1 += b0
    return x1

for prime_idx, prime in enumerate(primes):
    new(conn, prime, all_zeroes)
    for i in range(32):
        add(conn, all_zeroes)
        received = get(conn)
        reduced = [d for d in received if d != 0]
        if reduced:
            mapped[prime] = prime - reduced[0]
            # only in modified testserver
            # assert (p % prime == mapped[prime])
            # print("OK!")
            break
        print(f'{prime_idx} of {len(primes)} {i=}')


moduli = [mapped[prime] for prime in primes]
recovered = chinese_remainder(primes, moduli)

print('FLAG=')
for cipher in ciphertexts:
    print(chr(dghv_decrypt(recovered, 128, cipher)), end='')

print('')
</code></pre>
