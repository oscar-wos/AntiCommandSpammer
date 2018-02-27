# AntiCommandSpammer

Allows excessive configuration of what commands are able to be spammed / not spammed and at what interval.

### Installing

Drag the compiled .smx, and translations or download the whole scripting folder and compile yourself. Server needs a map change in order to load translations into memory.

### Config

Config is simply set with the command name, and the interval frequency of how often they can do it.

For example: `sm_w 10` - This would mean a player can only use the command `sm_w` every `10` seconds. Any attempt before the `10` second refresher will be nulled, and their refresh timer will be readjusted re-accordingly.

### Compiler

Pawn 1.8 - build 6041

## Built With

* [SourcePawn](https://www.sourcemod.net) - Interface to CS:GO

## Authors

* **Oscar Wos** - *Whole Project* - [AlliedModders](https://forums.alliedmods.net/member.php?u=261698) | [GitHub](https://github.com/OSCAR-WOS)

## License

This project is licensed under the GPL V3 License - see the [LICENSE](LICENSE) file for details
