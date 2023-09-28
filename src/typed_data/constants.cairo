const STARKNET_MESSAGE_PREFIX: felt252 = 'StarkNet Message';

// sn_keccak('StarkNetDomain(name:felt252,chainId:felt252,version:felt252)')
// const STARKNET_DOMAIN_TYPE_HASH: felt252 = 0x38938178ebdf241a3764698e540ead3e19ed2fb6120e27429961a2378e8b51;
// sn_keccak('StarkNetDomain(name:felt,version:felt,chain_id:felt))
const STARKNET_DOMAIN_TYPE_HASH: felt252 = 0x3cc62ca841ceeb3459f7fc9fdd66a29f6e65220babe2a4ce98fe2a2240a4155;

// sn_keccak('u256(low:felt252,high:felt252)')
// const U256_TYPE_HASH: felt252 = 0x1094260a770342332e6a73e9256b901d484a438925316205b4b6ff25df4a97a;

// sn_keccak('u256(low:felt,high:felt)')
const U256_TYPE_HASH: felt252 = 0x2ee86241508f9ca7043fb572033e45c445012a8dbb2b929391d37fc44fbfceb;

