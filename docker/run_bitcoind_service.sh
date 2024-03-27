#!/usr/bin/env bash

/usr/bin/bitcoind -server -regtest -txindex -zmqpubhashtx=tcp://127.0.0.1:30001 -zmqpubhashblock=tcp://127.0.0.1:30001 -rpcworkqueue=32 &
disown
sleep 2
/usr/bin/bitcoin-cli -regtest createwallet default
ADDRESS=$(/usr/bin/bitcoin-cli -regtest getnewaddress "" bech32)
/usr/bin/bitcoin-cli -regtest generatetoaddress 432 $ADDRESS

# Start mining in the background
(
    while true; do
        /usr/bin/bitcoin-cli -regtest generatetoaddress 1 $ADDRESS
        sleep 5
    done
) &

# Disown the background mining process so it doesn't terminate when the script ends
disown