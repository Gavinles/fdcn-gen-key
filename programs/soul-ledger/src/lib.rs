use anchor_lang::prelude::*;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
pub mod soul_ledger {
    use super::*;
    pub fn create_identity(ctx: Context<CreateIdentity>) -> Result<()> {
        let s = &mut ctx.accounts.account_state;
        s.owner = *ctx.accounts.user.key;
        s.fex_balance = 100 * 10u64.pow(6);
        s.su_balance = 1;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct CreateIdentity<'info> {
    #[account(init, payer = user, space = 8 + 32 + 8 + 8, seeds = [b"state".as_ref(), user.key().as_ref()], bump)]
    pub account_state: Account<'info, AccountState>,
    #[account(mut)] pub user: Signer<'info>, pub system_program: Program<'info, System>,
}

#[account]
pub struct AccountState {
    pub owner: Pubkey,
    pub fex_balance: u64,
    pub su_balance: u64,
}
