Update
------
TRIMCheck may no longer be necessary as of 10.10.4, which includes a
command line tool called `trimforce`. However, TRIMCheck will cause
no harm, and will let you know if TRIM is ever disabled, for whatever reason.

TRIMCheck
=========
Verify TRIM is enabled on your SSD drive when your Mac boots.

This is for use with the technique that enables TRIM on 3rd party SSD drives
described here (pre-10.10.4 only): https://gist.github.com/return1/4058659

That technique patches your block storage driver, which may be updated
when OS X updates and therefore cause TRIM to be disabled again. TRIMCheck
keeps track of the TRIM status on your SSD drive and reminds you do
rerun the commands in the linked gist in case the TRIM status changes.

For OS X 10.10.4 and later, trim support is enabled with: `sudo trimforce enable`.

Download
========
You can download [TRIMCheck from SourceForge](http://sourceforge.net/projects/trimcheck/files/TRIMCheck.pkg/download).
