{ ... }:
{
    programs.regreet = {
        enable = true;
            # For this example you'd need to have a version of Adwaita and the font Cantarell installed
        theme.name = "Adwaita";
        font = {
        name = "Cantarell";
        size = 16;
        };
        cursorTheme.name = "Adwaita";

        settings = {
            skip_selection = true;
        };
    };
}
