use messages::typed_data::typed_data::TypedDataTrait;
use core::traits::Into;
use array::ArrayTrait;
use starknet::testing;

// locals
use messages::messages::Messages;
use super::constants::{ CHAIN_ID, DOMAIN };
use super::utils;
use super::mocks::signer::Signer;
use super::mocks::voucher::Voucher;
use super::mocks::order::{ Order, Item, ERC20_Item, ERC1155_Item };
use messages::messages::Messages::{ ContractState as MessagesContractState, InternalTrait };
use debug::PrintTrait;

// dispatchers
use rules_account::account::{ AccountABIDispatcher, AccountABIDispatcherTrait };

//
// VOUCHERS
//

fn VOUCHER_1() -> Voucher {
  Voucher {
    receiver: starknet::contract_address_const::<'receiver 1'>(),
    token_id: u256 { low: 'token id 1 low', high: 'token id 1 high' },
    amount: u256 { low: 'amount 1 low', high: 'amount 1 high' },
    salt: 1,
  }
}

fn VOUCHER_SIGNATURE_1() -> Span<felt252> {
  array![
    3087695227963934782411443355974054330531912780999299366340358158172188798955,
    2936225994738482437582710271434813684883822280549795930447609837161446520483,
  ].span()
}

fn VOUCHER_SIGNATURE_2() -> Span<felt252> {
  array![
    1567101499423974405132552866654397941796461247734137894210715097651800024623,
    2406489013391837256524712835539748966140428060639388300020587314195643879538,
  ].span()
}

fn VOUCHER_SIGNER_PUBLIC_KEY() -> felt252 {
  0x1f3c942d7f492a37608cde0d77b884a5aa9e11d2919225968557370ddb5a5aa
}

fn VOUCHER_SIGNER() -> starknet::ContractAddress {
  starknet::contract_address_const::<0x1>()
}

//
// ORDERS
//

fn ORDER_1() -> Order {
  Order {
    offer_item: Item::ERC1155(ERC1155_Item {
      token: starknet::contract_address_const::<'offer token 1'>(),
      identifier: u256 { low: 'offer id 1 low', high: 'offer id 1 high' },
      amount: u256 { low: 'offer qty 1 low', high: 'offer qty 1 high' },
    }),
    consideration_item: Item::ERC20(ERC20_Item {
      token: starknet::contract_address_const::<'consideration token 1'>(),
      amount: u256 { low: 'cons qty 1 low', high: 'cons qty 1 high' },
    }),
    end_time: 103374043,
    salt: 'salt 1',
  }
}

fn ORDER_SIGNATURE_1() -> Span<felt252> {
  array![
    3237959813748497657862449788898314067503717469340761365314380802108721860625,
    1398567426642486998238399998023820315663915285444134720048195322876322419898,
  ].span()
}

fn ORDER_SIGNER_PUBLIC_KEY() -> felt252 {
  0x1766831fbcbc258a953dd0c0505ecbcd28086c673355c7a219bc031b710b0d6
}

fn ORDER_SIGNER() -> starknet::ContractAddress {
  starknet::contract_address_const::<0x2>()
}

fn ORDER_SIGNATURE_TEST_1() -> Span<felt252> {
  array![
    273659160181313831578376576325657925010370496743030782422643022462611126060,
    799087019070949953371110384076568138606612422147627361282474409338291304590,
  ].span()
}

fn ORDER_SIGNER_TEST_KEY() -> felt252 {
  0x2b191c2f3ecf685a91af7cf72a43e7b90e2e41220175de5c4f7498981b10053
}

fn ORDER_SIGNER_TEST() -> starknet::ContractAddress {
  starknet::contract_address_const::<0x3>()
}

fn setup() -> MessagesContractState {
  // setup chain id to compute vouchers hashes
  testing::set_chain_id(CHAIN_ID());

  // setup voucher signer - 0x1
  let voucher_signer = setup_signer(VOUCHER_SIGNER_PUBLIC_KEY());

  // setup voucher signer - 0x1
  let order_signer = setup_signer(ORDER_SIGNER_PUBLIC_KEY());
  let order_signer_test = setup_signer(ORDER_SIGNER_TEST_KEY());

  assert(voucher_signer.contract_address == VOUCHER_SIGNER(), 'Invalid voucher signer addr');
  assert(order_signer.contract_address == ORDER_SIGNER(), 'Invalid voucher signer addr');
  assert(order_signer_test.contract_address == ORDER_SIGNER_TEST(), 'Invalid signer test addr');

  Messages::contract_state_for_testing()
}

fn setup_signer(public_key: felt252) -> AccountABIDispatcher {
  let calldata = array![public_key];

  let signer_address = utils::deploy(Signer::TEST_CLASS_HASH, calldata);
  AccountABIDispatcher { contract_address: signer_address }
}

// SIGNATURE

// #[test]
// #[available_gas(20000000)]
// fn test__is_message_signature_valid_voucher() {
//   let mut messages = setup();

//   let voucher_signer = VOUCHER_SIGNER();

//   let domain = DOMAIN();
//   let voucher = VOUCHER_1();

//   let hash = voucher.compute_hash_from(from: voucher_signer, :domain);
//   let signature = VOUCHER_SIGNATURE_1();

//   assert(messages._is_message_signature_valid(:hash, :signature, signer: voucher_signer), 'Invalid voucher signature');
// }

// #[test]
// #[available_gas(20000000)]
// fn test__is_message_signature_valid_order() {
//   let mut messages = setup();

//   let order_signer = ORDER_SIGNER();

//   let domain = DOMAIN();
//   let order = ORDER_1();
//   order_signer.print(); 
//   let hash = order.compute_hash_from(from: order_signer, :domain);
//   hash.print();
//   let signature = ORDER_SIGNATURE_1();

//   assert(messages._is_message_signature_valid(:hash, :signature, signer: order_signer), 'Invalid order signature');
// }

// #[test]
// #[available_gas(20000000)]
// fn test__is_message_signature_invalid_voucher() {
//   let mut messages = setup();

//   let voucher_signer = VOUCHER_SIGNER();

//   let domain = DOMAIN();
//   let mut voucher = VOUCHER_1();
//   voucher.amount += 1;

//   let hash = voucher.compute_hash_from(from: voucher_signer, :domain);
//   let signature = VOUCHER_SIGNATURE_1();

//   assert(!messages._is_message_signature_valid(:hash, :signature, signer: voucher_signer), 'Invalid voucher signature');
// }

// #[test]
// #[available_gas(20000000)]
// fn test__is_message_signature_invalid_order() {
//   let mut messages = setup();

//   let order_signer = ORDER_SIGNER();

//   let domain = DOMAIN();
//   let mut order = ORDER_1();
//   order.salt += 1;

//   let hash = order.compute_hash_from(from: order_signer, :domain);
//   let signature = ORDER_SIGNATURE_1();

//   assert(!messages._is_message_signature_valid(:hash, :signature, signer: order_signer), 'Invalid order signature');
// }

// // Message consumption

// #[test]
// #[available_gas(20000000)]
// fn test_message_consumption() {
//   let mut messages = setup();

//   let hash = 'hash';

//   assert(!messages._is_message_consumed(:hash), 'Should not be consumed');

//   messages._consume_message(:hash);

//   assert(messages._is_message_consumed(:hash), 'Should not be consumed');
// }

// #[test]
// #[available_gas(20000000)]
// fn test_signature() {
//   let mut messages = setup();

//   let order_signer = ORDER_SIGNER_TEST();

//   // let domain = DOMAIN();
//   // let order = ORDER_1();

//   // let hash = order.compute_hash_from(from: order_signer, :domain);
//   let hash = '0x1'.into();
//   let signature = ORDER_SIGNATURE_TEST_1();

//   assert(messages._is_message_signature_valid(:hash, :signature, signer: order_signer), 'Invalid order signature');
// }
