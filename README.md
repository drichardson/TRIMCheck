TRIMCheck
=========
Verify TRIM is enabled on your SSD drive when your Mac boots.

This is for use with the technique that enables TRIM on 3rd party SSD drives
described here: https://gist.github.com/return1/4058659

That technique patches your block storage driver, which may be updated
when OS X updates and therefore cause TRIM to be disabled again. TRIMCheck
keeps track of the TRIM status on your SSD drive and reminds you do
rerun the commands in the linked gist in case the TRIM status changes.

Download
========
You can download [TRIMCheck from SourceForge](http://sourceforge.net/projects/trimcheck/files/TRIMCheck.pkg/download).
