# The modularization handbook

## This is a very simplified version of Nova Sector's guide since I know full well it won't matter too much if the code is a little messy. It's SS13 anyways so even then does it really matter that much?

## You should probably still follow this guide anyways just because it's MUCH easier, even with this barebones piece of turds

## Introduction

Developing a seperate codebase is a big task, especially in regards to keeping up with the latest changes. Due to the nature of Git, changes upstream can lead to extra effort required to bring them here. This is exacerbated when you are editing the vanilla code, causing mountains of merge conflicts (not good!)

Modularization helps avoid this by modifying /tg/'s code as little as possible, instead opting to put our code in its own seperate folder (`/hzc_modules`).

## Important note - TEST YOUR PULL REQUESTS, DICKWAD

You are responsible for the testing of your content. You should not mark a pull request ready for review until you have actually tested it. If you require a separate client for testing, you can use a guest account by logging out of BYOND and connecting to your test server. Test merges are not for bug finding, they are for stress tests where local testing simply doesn't allow for this.

## The modularization protocol

Always start by thinking of the theme/purpose of your work. It's oftentimes a good idea to see if there isn't an already existing module that you can append  your code to.

**If it's a tgcode-specific tweak or bugfix, you should probably try to PR it upstream, instead of needlessly modularizing it here.**

Otherwise, pick a new ID for your module. E.g. `dna_feature_wings` or `sex_update` or `shuttle_toggle` - We will use this in future documentation. It is essentially your module ID. It must be uniform throughout the entire module. All references MUST be exactly the same. This is to allow for easy searching.

And then you'll want to establish your core folder that you'll be working out of which is normally your module ID. E.g. `/hzc_modules/modules/shuttle_toggle`

All assets should be formatted in folders similarly to how it is in /tg/. For example, let's say I wanted to add a new door type. Since other door types put their code in the `/code/game/machinery/doors` folder, I should put it in the `/hzc_modules/my_beautiful_module/code/game/machinery/doors/my_sick_ass_door_type.dm`. Do the same for all other assets - icons, sounds, etc.

### Defines

Put all modular defines in **`code/__DEFINES/hzc_defines`** - you can either add them to the existing files, or create new ones when needed.

If you have a define that's used in more than one file, it **must** be declared here.

If you have a define that's used in one file, and won't be used anywhere else, declare it at the top, and `#undef MY_DEFINE` at the bottom of the file. This is to keep context menus clean, and to prevent confusion by those using IDEs with autocomplete.

### Commenting out code - DON'T DO IT

If you are commenting out redundant code in modules, do not comment it out, instead, delete it.

Even if you think someone is going to redo whatever it is you're commenting out, don't, gitblame exists for a reason.

This also applies to files, do not comment out entire files, just delete them instead. Why the fuck you would do this is far beyond me but whatever.

**This does not apply to non-modular changes.**

## Modular TGUI

TGUI is another exceptional case, since it uses javascript and isn't able to be modular in the same way that DM code is.
ALL of the tgui files are located in `/tgui/packages/tgui/interfaces` and its subdirectories; just toss your code in there and don't worry about putting it in any specific folders.
