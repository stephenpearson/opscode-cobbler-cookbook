# Copyright 2016, Stephen Pearson
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "cobbler::default"

cobbler_import_iso "ubunty-trusty64" do
  url "http://192.168.66.1/ubuntu-14.04.4-server-amd64.iso"
  sha256 "07e4bb5569814eab41fafac882ba127893e3ff0bdb7ec931c9b2d040e3e94e7a"
end

cobbler_repo "ubuntu-trusty64" do
  apt_components ['main', 'universe']
  apt_dists ['trusty', 'trusty-updates', 'trusty-security']
  arch "x86_64"
  breed "apt"
  mirror "http://gb.archive.ubuntu.com/ubuntu/"
  local_mirror false
end

cobbler_distro "ubuntu-trusty64" do
  KS_BASE="/var/www/cobbler/ks_mirror/ubuntu-trusty64/install/netboot"
  arch "x86_64"
  breed "ubuntu"
  initrd "#{KS_BASE}/ubuntu-installer/amd64/initrd.gz"
  kernel "#{KS_BASE}/ubuntu-installer/amd64/linux"
  kickstart_metadata({
    "tree" => "http://@@http_server@@/cblr/links/ubuntu-trusty64" })
  os_version "trusty"
end

cobbler_profile "ubuntu-trusty64-chef-server" do
  dhcp_tag "default"
  distro "ubuntu-trusty64"
  enable_gpxe false
  enable_menu true
  kickstart "/var/lib/cobbler/kickstarts/ubuntu-trusty64.preseed"
  owners [ "admin" ]
  virt_bridge "virbr0"
  virt_auto_boot true
  virt_cpus 1
  virt_disk_driver "raw"
  virt_file_size 5
  virt_type "kvm"
end

