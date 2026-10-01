{ ... }:
{
# 开启 ⚙️ KVM 虚拟化支持
  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  users.users.kid.extraGroups = [ "libvirtd" ];
}
