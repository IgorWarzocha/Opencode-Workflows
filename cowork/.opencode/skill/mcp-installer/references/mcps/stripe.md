---
name: stripe
url: https://docs.stripe.com/mcp
type: remote
auth: oauth
description: Stripe payment integration
tags: [stripe, payments, oauth]
---

# Stripe MCP

Official Stripe server for payment API integration.

## Installation

**Remote:**
```jsonc
{
  "mcp": {
    "stripe": {
      "type": "remote",
      "url": "https://mcp.stripe.com",
      "oauth": {}
    }
  }
}
```

**Local:**
```jsonc
{
  "mcp": {
    "stripe": {
      "type": "local",
      "command": ["npx", "-y", "@stripe/mcp", "--tools=all"],
      "environment": {
        "STRIPE_SECRET_KEY": "{env:STRIPE_SECRET_KEY}"
      }
    }
  }
}
```

## Setup

**Remote:**
```bash
opencode mcp auth stripe
```

**Local:** Set `STRIPE_SECRET_KEY` environment variable.

## Usage

"Create a Stripe payment link using stripe MCP"

"List recent PaymentIntents with stripe"

## Features

- Account, customer, and product management
- Payment links and PaymentIntents
- Invoices and subscriptions
- Refunds and disputes
- Search Stripe docs and resources

## Links

- [Docs](https://docs.stripe.com/mcp)
- [GitHub](https://github.com/stripe/ai/tree/main/tools/modelcontextprotocol)
