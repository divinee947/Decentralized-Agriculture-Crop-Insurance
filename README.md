# Decentralized Agriculture Crop Insurance

A comprehensive blockchain-based crop insurance system built on Stacks using Clarity smart contracts. This system provides transparent, automated, and decentralized crop insurance services for farmers.

## Overview

This project implements a complete crop insurance ecosystem with the following components:

- **Insurer Verification**: Validates and manages insurance providers
- **Risk Assessment**: Evaluates crop insurance risks based on multiple factors
- **Policy Management**: Handles insurance policy creation and management
- **Claim Processing**: Automates claim submission and processing
- **Weather Integration**: Incorporates real-time weather data for risk assessment

## Smart Contracts

### 1. Insurer Verification Contract (\`insurer-verification.clar\`)
- Manages verification of insurance providers
- Stores insurer details and licensing information
- Provides authorization controls for verified insurers

### 2. Risk Assessment Contract (\`risk-assessment.clar\`)
- Evaluates crop risks based on weather, soil quality, and historical data
- Calculates premium multipliers based on risk levels
- Maintains regional crop risk profiles

### 3. Policy Management Contract (\`policy-management.clar\`)
- Creates and manages insurance policies
- Handles premium payments and policy cancellations
- Tracks policy status and expiration

### 4. Claim Processing Contract (\`claim-processing.clar\`)
- Processes insurance claims from farmers
- Manages claim assessment and approval workflow
- Handles automated payouts for approved claims

### 5. Weather Integration Contract (\`weather-integration.clar\`)
- Integrates weather data from authorized oracles
- Creates weather alerts for high-risk conditions
- Calculates weather-based risk factors

## Features

- **Decentralized Verification**: Transparent insurer verification process
- **Automated Risk Assessment**: Data-driven risk evaluation
- **Smart Policy Management**: Automated policy lifecycle management
- **Transparent Claims**: Immutable claim processing records
- **Weather Oracle Integration**: Real-time weather data integration
- **Multi-stakeholder Support**: Farmers, insurers, and assessors

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd decentralized-crop-insurance
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:

\`\`\`bash
# Deploy insurer verification contract
clarinet deploy --testnet contracts/insurer-verification.clar

# Deploy other contracts in order
clarinet deploy --testnet contracts/risk-assessment.clar
clarinet deploy --testnet contracts/policy-management.clar
clarinet deploy --testnet contracts/claim-processing.clar
clarinet deploy --testnet contracts/weather-integration.clar
\`\`\`

## Usage

### For Farmers
1. Browse verified insurers
2. Get risk assessment for your crops
3. Purchase insurance policies
4. Submit claims when needed

### For Insurers
1. Get verified through the verification contract
2. Create insurance policies for farmers
3. Assess and process claims
4. Monitor weather conditions

### For Assessors
1. Get authorized to assess claims
2. Review submitted claims
3. Approve or reject claims based on evidence

## Contract Interactions

### Creating a Policy
\`\`\`clarity
(contract-call? .policy-management create-policy
farmer-principal
insurer-principal
"corn"
"midwest-usa"
u10000
u500
u52560) ;; 1 year in blocks
\`\`\`

### Submitting a Claim
\`\`\`clarity
(contract-call? .claim-processing submit-claim
policy-id
u8000
u80
"evidence-hash-here")
\`\`\`

### Weather Data Submission
\`\`\`clarity
(contract-call? .weather-integration submit-weather-data
"midwest-usa"
u20240101
25
u45
u65
u15)
\`\`\`

## Testing

The project includes comprehensive tests for all contracts:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment
- Function calls and responses
- Error handling
- Edge cases
- Integration scenarios

## Security Considerations

- All contracts implement proper authorization checks
- Input validation prevents malicious data
- State changes are atomic and consistent
- Oracle data is verified before use

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the GitHub repository.
\`\`\`

Now let's create the PR details file:
