use anchor_lang::prelude::*;

declare_id!("5oxVbQ8n8vsR4fBBUr4eCf9d6PR7oqJjUpsBfG84LtCZ");

#[program]
pub mod nasaft2 {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
