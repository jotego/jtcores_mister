# JTCORES for MiSTer

This repository contains all of [Jotego's](https://twitter.com/topapate) cores and related files ready for usage on [MiSTer](https://github.com/MiSTer-devel/Main_MiSTer/wiki).

Jotego's arcade cores offer the most accurate arcade experience in modern hardware using FPGA technology.

Please support Jotego's work:
* Patreon: https://patreon.com/topapate
* Paypal: https://paypal.me/topapate
* Github: https://github.com/sponsors/jotego

Downloader development by theypsilon (support him on [Patreon](https://www.patreon.com/theypsilon))

## Download

You may download all of them at once as a zip through the [following link](https://github.com/jotego/jtcores_mister/archive/refs/heads/main.zip). Once you have them, place them as-is in your [properly initialised SD card](https://github.com/MiSTer-devel/mr-fusion), and everything should work out of the box.

The source code for these files is kept in independent repositories [here](https://github.com/jotego).

### Install all the files with Update All for MiSTer

[Update All](https://github.com/theypsilon/Update_All_MiSTer) will, by default, install all these files directly from your MiSTer. To also install the premium betas, open the Setting Screen that you can access by pressing up during Update All's countdown, and activate the premium option under JTCORES menu.

### Manual MiSTer Downloader Configuration

The [Downloader](https://github.com/MiSTer-devel/Downloader_MiSTer) tool can be configured for downloading all these files too. If you are not getting the files automatically, add manually this database to `/media/fat/downloader.ini`. Add these lines to the end of the file:

```ini
[jtcores]
db_url = https://raw.githubusercontent.com/jotego/jtcores_mister/main/jtbindb.json.zip

```

By default it won't include premium betas. To also include the premium betas, add the following filter to it:

```ini
[jtcores]
db_url = https://raw.githubusercontent.com/jotego/jtcores_mister/main/jtbindb.json.zip
filter = [mister]
```

#### List of Tags that you may use with the Downloader Filters:

`alternatives`, `arcade`, `arcade-cores`, `arcade-jt1942`, `arcade-jt1943`, `arcade-jtaliens`, `arcade-jtbiocom`, `arcade-jtbtiger`, `arcade-jtbubl`, `arcade-jtcastle`, `arcade-jtcircus`, `arcade-jtcommnd`, `arcade-jtcomsc`, `arcade-jtcontra`, `arcade-jtcop`, `arcade-jtcps1`, `arcade-jtcps15`, `arcade-jtcps2`, `arcade-jtdd`, `arcade-jtdd2`, `arcade-jtexed`, `arcade-jtflane`, `arcade-jtflstory`, `arcade-jtfround`, `arcade-jtgaiden`, `arcade-jtgng`, `arcade-jtgunsmk`, `arcade-jtkarnov`, `arcade-jtkchamp`, `arcade-jtkicker`, `arcade-jtkiwi`, `arcade-jtkunio`, `arcade-jtlabrun`, `arcade-jtmidres`, `arcade-jtmikie`, `arcade-jtmx5k`, `arcade-jtngp`, `arcade-jtngpc`, `arcade-jtninja`, `arcade-jtoutrun`, `arcade-jtpang`, `arcade-jtparoda`, `arcade-jtpinpon`, `arcade-jtrastan`, `arcade-jtriders`, `arcade-jtroadf`, `arcade-jtroc`, `arcade-jtrumble`, `arcade-jts16`, `arcade-jts16b`, `arcade-jts18`, `arcade-jtsarms`, `arcade-jtsbaskt`, `arcade-jtsectnz`, `arcade-jtsf`, `arcade-jtshanon`, `arcade-jtshouse`, `arcade-jtsimson`, `arcade-jtslyspy`, `arcade-jttmnt`, `arcade-jttoki`, `arcade-jttora`, `arcade-jttrack`, `arcade-jttrojan`, `arcade-jttwin16`, `arcade-jtvigil`, `arcade-jtwc`, `arcade-jtwwfss`, `arcade-jtxmen`, `arcade-jtyiear`, `console`, `console-cores`, `cores`, `games`, `mra`, `neo`, `neogeopocket`

### Other Platforms

These cores are also available for MiST, SiDi, NeptUNO, MultiCore and MultiCore 2+. For these platforms check the [JTBIN](https://github.com/jotego/jtbin) repository.
