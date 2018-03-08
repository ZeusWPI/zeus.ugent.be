import socket

for i in range(256):
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect(("52.210.242.66", 8024))

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.connect(("52.210.242.66", 8023))

    # Forward client hello to server
    hi = client.recv(1000);
    server.send(hi)

    # Forward server hello to client
    hey = server.recv(1000);
    client.send(hey)

    # Forward get_flag command to server
    getFlag = client.recv(1000)
    server.send(getFlag)

        
    # Intercept the encrypted flag
    flag = bytearray(server.recv(1000))

    # Change message type to server hello to avoid HMAC check
    flag[1] = 1
    # Change length of first (and only data block) to result in error and printed flag bytes
    flag[-41+1] = flag[-41+1]^0x27^i

    client.send(flag)

    # Read and print error
    r = client.recv(1000)
    print r[20:] 

# TODO: task someone else with converting hex bytes to ascii chars
