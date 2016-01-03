
SyncSeedBox
===========

Scripts for syncing my seedbox.

## Sync-Feral-RSync ##

Syncing my completed forlder then deletes files from it. The files are hardlinked to the downloaded torrents, so they original are not deleted when it is sync.

It also uses a LOG file that I can read after in my personal share, or on my server.

When it is finished, the script calls another one on my server via SSH to remove the empty directories.