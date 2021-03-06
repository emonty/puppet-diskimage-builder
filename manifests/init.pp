# Copyright 2015 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# == Class: diskimage_builder
#
class diskimage_builder () {
  include pip

  $packages = [
    'debian-keyring',
    'debootstrap',
    'kpartx',
    'python-lzma',
    'qemu-utils',
    'ubuntu-keyring',
    'vhd-util',
    'yum',
    'yum-utils',
  ]

  package { $packages:
    ensure => present,
    require => Apt::Ppa['ppa:mordred/infra'],
  }

  apt::ppa { 'ppa:mordred/infra':
    ensure => present,
  }

  # required by the diskimage-builder element scripts
  if ! defined(Package['python-yaml']) {
      package { 'python-yaml':
          ensure => present,
      }
  }

  package { 'diskimage-builder':
    ensure   => latest,
    provider => pip,
    require  => [
      Class['pip'],
      Package['python-yaml'],
    ],
  }

}
