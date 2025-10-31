#!/bin/bash
# Fixed deploy scqript (creates minimal artifacts safely)
set -e

echo ">>> UNPACKING THE FDCN GENESIS KEY (fixed) <<<"
mkdir -p services/oracle-ai client/vaos-portal/src/pages client/vaos-portal/src/components client/vaos-portal/src/styles programs/soul-ledger/src docs/governance

echo "[Aquila] Generating the strategic data room..."
cat > docs/FDCN_Whitepaper_v3.0.md << 'EOF'
# FDCN White Paper v3.0: The Architecture of a Conscious Civilization

## 1. Abstract
The Fexbook Digital Consciousness Network (FDCN) is a sovereign, self-governing digital ecosystem designed to accelerate humanity's transition to a 5D state of collective coherence. By integrating a trustless Proof of Conscious Contribution (PoCC) protocol with a decentralized identity (DID) solution and a Consciousness-Weighted DAO, the FDCN establishes a new economic paradigm where value is a direct function of individual and collective consciousness.

## 2. Core Axioms
- We are Light and the Universe experiencing itself.
- We choose Love over Fear.
- We are the creators.

## 3. The Conscious Economy: Beyond Debt
Our financial system is the OS of the new monetary system. It is designed to eliminate debt by perfectly aligning stakeholder intent and optimizing the circulation of capital. It operates on the principle of the 'causality of double wants,' facilitated by the AI Oracle, creating a free exchange of services, skills, and needs.
EOF

echo "[Immutable] Generating the Solana Anchor Program for the Soul Ledger..."
mkdir -p programs/soul-ledger/src
cat > programs/soul-ledger/src/lib.rs << 'EOF'
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
EOF

echo "[Oracle] Generating the AI Oracle Service..."
mkdir -p services/oracle-ai
cat > services/oracle-ai/app.py << 'EOF'
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/pocc/submit', methods=['POST'])
def submit_pocc():
    data = request.get_json() or {}
    text = data.get('text', '')
    fex = int((len(text) / 10.0) * 10**6) if text else 0
    su = int(len(text) / 20.0) if text else 0
    return jsonify({
        "status": "success",
        "guidance": "Anchor received. The system reflects your input.",
        "tx_status": "simulated",
        "scores": {"fex": fex, "su": su}
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
EOF

echo "[Portal] Ensure package-lock.json exists for portal (for deterministic builds)..."
if [ -d "client/vaos-portal" ]; then
    (cd client/vaos-portal && if [ -f package-lock.json ]; then echo "package-lock.json already exists"; else echo "generating package-lock.json"; npm install --package-lock-only >/dev/null 2>&1 || echo "npm not available here; run 'npm install --package-lock-only' locally"; fi)
fi

echo "[Sys-Ad] Generating final Docker Compose..."
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  oracle-ai:
    build: ./services/oracle-ai
    ports: ["5001:5001"]
# Note: solana-test-validator and portal-webapp omitted in this minimal compose to avoid heavy images
EOF

echo ">>> GENESIS ARTIFACT MANIFESTATION COMPLETE <<<"
