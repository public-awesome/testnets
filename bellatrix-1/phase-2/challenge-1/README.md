# Phase-2 Challenge 1 - Deadline: 13-04-2021 16:00 UTC

## 1.- Fork the repo / Sync the repo

If you already forked the repo see how to sync it https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork, ensure that your fork is up to date with the upstream repository to avoid conflicts.

## 2.- Create a phase-2-challenge-1 branch on your forked repository

`git checkout -b phase-2-challenge-1`

## 3.- Submit TX information

Create a new `<my_moniker>.json` file where <my_moniker> is the name of your validator (as seen on the explorer) following the template in `bellatrix-1/phase-2/challenge-1`

```json
{
  "operator_address": "starsvaloper...",
  "moniker": "<my_moniker>",
  "post_tx_hash": "hash",
  "upvote_tx_hash": "hash",
  "upvote_2_tx_hash": "hash",
  "stake_tx_hash": "hash"
}
```

## 4.- Open a pull request

Open a pull request from your `phase-2-challenge-1` branch targeting master with title **Phase 2: Challenge-1**
