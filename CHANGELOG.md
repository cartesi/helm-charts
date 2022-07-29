# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Changed

- Add rollups-inspect-server container
- Add postgres-operator optional values configuration
- Replace .Values.dapp.chainID for .Values.dapp.network
- Extract server-manager to its own Pod
- Adapt to new state-server and dispatcher containers

### Fixed

- validator Pod values

## [0.1.0] 2022-07-11

### Add

- rollups-validator-node helm chart
