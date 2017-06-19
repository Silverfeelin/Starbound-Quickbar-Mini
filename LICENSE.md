## Disclaimer
This repository consists mostly of source files from [zetaPRIME](https://github.com/zetaPRIME)'s [sb.StardustSuite](https://github.com/zetaPRIME/sb.StardustSuite) mod.  
Some small additions and modifications allow use of the Quickbar on servers that don't have the mod or [StardustLib](https://github.com/zetaPRIME/sb.StardustSuite#stardustlib), without any issues.

Permission for the creation and distribution of this standalone version was given by zetaPRIME directly.
For licensing information, please refer to the [sb.StardustSuite](https://github.com/zetaPRIME/sb.StardustSuite) repository.

## Modified sources

~ `/sys/stardust/openinterface.lua`

* Changed `openInterface` to make use of [ItemScripts][ItemScripts], for server compatibility.

\+ `/sys/stardust/quickbar/quickbarItem.config`

* Defines the item for the [ItemScripts][ItemScripts] implementation.

[ItemScripts]:https://github.com/Silverfeelin/Starbound-ItemScripts