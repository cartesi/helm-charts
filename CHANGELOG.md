# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] TBD

### Added

- enable service configuration via values.yaml for:
  - dispatcher
  - state-server
  - indexer
  - server-manager
  - inspect-server
- configuration for Optimism Goerli and Arbitrum Goerli

### Changed

- usage of .Release.Name for Ingress rules[].host: is now disabled by default

### Fixed

- default POSTGRES_PORT for indexer
- port for inspect service

## [0.2.0] 2022-08-17

### Added

- Add rollups-inspect-server container
- Add postgres-operator optional values configuration
- .Values.validator.dispatcher.txDatabasePath option
- Optional `args: []` to some containers
- Optional `extraEnvVars: []` to some containers
- Ingress with the helm release name as additional DNS (eg.: my-dapp.example.com)

### Changed

- Replace .Values.dapp.chainID for .Values.dapp.network
- Extract server-manager to its own Pod
- Adapt to new state-server and dispatcher containers

### Fixed

- validator Pod values
- replicaCount usage

## [0.1.0] 2022-07-11

### Added

- rollups-validator-node helm chart