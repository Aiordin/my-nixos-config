{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Clash Verge (mihomo) 代理管理（initContent 替代已弃用的 initExtra）：
    # - proxy on / proxy off 手动切换
    # - 启动时自动探测 7897 端口，仅在 mihomo 运行时启用，
    #   避免 clash 未启动时终端网络因 connection refused 全部失败
    initContent = ''
      # 手动切换代理
      proxy() {
        case "$1" in
          on)
            export http_proxy="http://127.0.0.1:7897"
            export https_proxy="http://127.0.0.1:7897"
            export all_proxy="socks5://127.0.0.1:7897"
            export no_proxy="localhost,127.0.0.1,::1"
            echo "proxy on: 127.0.0.1:7897"
            ;;
          off)
            unset http_proxy https_proxy all_proxy no_proxy \
                  HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
            echo "proxy off"
            ;;
          *)
            if [[ -n "$http_proxy" ]]; then
              echo "proxy on: $http_proxy"
            else
              echo "proxy off"
            fi
            ;;
        esac
      }

      # 启动时自动探测：mihomo 监听 7897 才启用代理
      if ss -tln 2>/dev/null | grep -q ':7897 '; then
        proxy on >/dev/null
      fi
    '';
  };


  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = (
        "[](#9A348E)"
        + "$os"
        + "$username"
        + "[](bg:#DA627D fg:#9A348E)"
        + "$directory"
        + "[](fg:#DA627D bg:#FCA17D)"
        + "$git_branch"
        + "$git_status"
        + "[](fg:#FCA17D bg:#86BBD8)"
        + "$c"
        + "$elixir"
        + "$elm"
        + "$golang"
        + "$gradle"
        + "$haskell"
        + "$java"
        + "$julia"
        + "$maven"
        + "$nodejs"
        + "$bun"
        + "$nim"
        + "$rust"
        + "$scala"
        + "[](fg:#86BBD8 bg:#06969A)"
        + "$docker_context"
        + "[](fg:#06969A bg:#33658A)"
        + "$time"
        + "[ ](fg:#33658A)"
      );

      # 各个模块的具体样式
      username = {
        show_always = true;
        style_user = "bg:#9A348E";
        style_root = "bg:#9A348E";
        format = "[$user ]($style)";
        disabled = false;
      };

      os = {
        style = "bg:#9A348E";
        disabled = true;
      };

      directory = {
        style = "bg:#DA627D";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "   ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      c = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      cpp = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:#06969A";
        format = "[ $symbol $context ]($style)";
      };

      elixir = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      elm = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      git_branch = {
        symbol = "";
        style = "bg:#FCA17D";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:#FCA17D";
        format = "[$all_status$ahead_behind ]($style)";
      };

      golang = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      gradle = {
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      haskell = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      julia = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      maven = {
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      bun = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      nim = {
        symbol = "   ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      scala = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#33658A";
        format = "[ ♥ $time ]($style)";
      };
    };
  };
}
