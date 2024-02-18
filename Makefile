-include .env

build:; forge build

deploy-fundsript:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SRPC_URL) --private-key $(SPRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHER_SCAN_API_KEY) -vvvv