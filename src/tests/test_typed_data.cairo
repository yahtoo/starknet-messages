use starknet::testing;

// locals
use messages::typed_data::TypedDataTrait;
use super::constants::{ CHAIN_ID, DOMAIN };
use super::mocks::voucher::Voucher;
use super::mocks::order::{ Order, Item, ERC20_Item, ERC1155_Item };
use debug::PrintTrait;

fn SIGNER() -> starknet::ContractAddress {
  starknet::contract_address_const::<0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826>()
}

fn OTHER() -> starknet::ContractAddress {
  starknet::contract_address_const::<'other'>()
}

fn VOUCHER() -> Voucher {
  Voucher {
    receiver: starknet::contract_address_const::<1>(),
    token_id: u256 { low: 2, high: 3 },
    amount: u256 { low: 4, high: 5 },
    salt: 6,
  }
}

fn VOUCHER_HASH() -> felt252 {
  0x6a0bb8dafde554d96eb3bcf536c8f43c57d8b56af4a84317f3e941f1b2e8fb4
}

// fn ORDER() -> Order {
//   Order {
//     offer_item: Item::ERC1155(ERC1155_Item {
//       token: starknet::contract_address_const::<1>(),
//       identifier: u256 { low: 2, high: 3 },
//       amount: u256 { low: 4, high: 5 },
//     }),
//     consideration_item: Item::ERC20(ERC20_Item {
//       token: starknet::contract_address_const::<6>(),
//       amount: u256 { low: 7, high: 8 },
//     }),
//     end_time: 9,
//     salt: 10,
//   }
// }

fn ORDER() -> Order {
  Order {
    offer_item: Item::ERC1155(ERC1155_Item {
      token: starknet::contract_address_const::<0x5b456031650c1de9eec123d3e7d06a684d321a346d4a7cac9fd86c2b77cf70f>(),
      identifier: 1,
      amount:1,
    }),
    consideration_item: Item::ERC20(ERC20_Item {
      token: starknet::contract_address_const::<0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7>(),
      amount: 100000,
    }),
    end_time: 9,
    salt: 10,
  }
}
fn ORDER_HASH() -> felt252 {
  0x52fc92eacf7be2ff8a45ec31d5394df02c5ee5e57268fd62aa25f34924169d2
}

//
// VOUCHER
//

// #[test]
// #[available_gas(20000000)]
// fn test_voucher_compute_hash_from_signer() {
//   testing::set_chain_id(CHAIN_ID());

//   let voucher = VOUCHER();

//   assert(voucher.compute_hash_from(from: SIGNER(), domain: DOMAIN()) == VOUCHER_HASH(), 'Invalid voucher hash')
// }

// #[test]
// #[available_gas(20000000)]
// fn test_voucher_compute_hash_from_signer_with_invalid_chain_id() {
//   testing::set_chain_id(CHAIN_ID() + 1);

//   let voucher = VOUCHER();

//   assert(voucher.compute_hash_from(from: SIGNER(), domain: DOMAIN()) != VOUCHER_HASH(), 'Invalid voucher hash')
// }

// #[test]
// #[available_gas(20000000)]
// fn test_voucher_compute_hash_from_other() {
//   testing::set_chain_id(CHAIN_ID());

//   let voucher = VOUCHER();

//   assert(voucher.compute_hash_from(from: OTHER(), domain: DOMAIN()) != VOUCHER_HASH(), 'Invalid voucher hash')
// }

// #[test]
// #[available_gas(20000000)]
// fn test_invalid_voucher_compute_hash_from_signer() {
//   testing::set_chain_id(CHAIN_ID());

//   let mut voucher = VOUCHER();
//   voucher.salt += 1;

//   assert(voucher.compute_hash_from(from: SIGNER(), domain: DOMAIN()) != VOUCHER_HASH(), 'Invalid voucher hash')
// }

// //
// // ORDER
// //

#[test]
#[available_gas(20000000)]
fn test_order_compute_hash_from_signer() {
  testing::set_chain_id(CHAIN_ID());
  // testing::set_chain_id(1);

  let order = ORDER();
  assert(order.compute_hash_from(from: SIGNER(), domain: DOMAIN()) == ORDER_HASH(), 'Invalid order hash')
}

// #[test]
// #[available_gas(20000000)]
// fn test_order_compute_hash_from_signer_with_invalid_chain_id() {
//   testing::set_chain_id(CHAIN_ID() + 1);

//   let order = ORDER();

//   assert(order.compute_hash_from(from: SIGNER(), domain: DOMAIN()) != ORDER_HASH(), 'Invalid order hash')
// }

// #[test]
// #[available_gas(20000000)]
// fn test_order_compute_hash_from_other() {
//   testing::set_chain_id(CHAIN_ID());

//   let order = ORDER();

//   assert(order.compute_hash_from(from: OTHER(), domain: DOMAIN()) != ORDER_HASH(), 'Invalid order hash')
// }

// #[test]
// #[available_gas(20000000)]
// fn test_invalid_order_compute_hash_from_signer() {
//   testing::set_chain_id(CHAIN_ID());

//   let mut order = ORDER();
//   order.salt += 1;

//   assert(order.compute_hash_from(from: SIGNER(), domain: DOMAIN()) != ORDER_HASH(), 'Invalid order hash')
// }
