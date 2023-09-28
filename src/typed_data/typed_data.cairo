use traits::Into;
use box::BoxTrait;

use super::constants;
use debug::PrintTrait;

#[derive(Serde, Copy, Drop)]
struct Domain {
  name: felt252,
  version: felt252,
}

trait Message<T> {
  fn compute_hash(self: @T) -> felt252;
}

trait TypedDataTrait<T> {
  fn compute_hash_from(self: @T, from: starknet::ContractAddress, domain: Domain) -> felt252;
}

impl TypedDataImpl<T, impl TMessage: Message<T>> of TypedDataTrait<T> {
  #[inline(always)]
  fn compute_hash_from(self: @T, from: starknet::ContractAddress, domain: Domain) -> felt252 {
    let tx_info = starknet::get_tx_info().unbox();
    let prefix = constants::STARKNET_MESSAGE_PREFIX;
    prefix.print();
    let domain_hash = hash_domain(chain_id: tx_info.chain_id, :domain);
    domain_hash.print();
    let account = from.into();
    account.print();
    let message_hash = self.compute_hash();
    message_hash.print();

    let mut hash = pedersen::pedersen(0, prefix);
    hash = pedersen::pedersen(hash, domain_hash);
    hash = pedersen::pedersen(hash, account);
    hash = pedersen::pedersen(hash, message_hash);

    hash = pedersen::pedersen(hash, 4);
    hash.print();
    hash
  }
}

fn hash_domain(chain_id: felt252, domain: Domain) -> felt252 {
  chain_id.print();
  let mut hash = pedersen::pedersen(0, constants::STARKNET_DOMAIN_TYPE_HASH);
  hash = pedersen::pedersen(hash, domain.name);
  hash = pedersen::pedersen(hash, domain.version);
  hash = pedersen::pedersen(hash, chain_id);

  pedersen::pedersen(hash, 4)
}
