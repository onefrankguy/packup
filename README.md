Packup
======

Packup is a Rake helper for building Windows installers. It helps you write simple MSI packages.

Synopsis
--------

Write a Rakefile:

    require 'packup'

    Packup.stuff 'Magic' do
      author 'Wizard'
      version '1.0.0'

      file 'src/README'   => '/docs/readme.txt'
      file 'src/wand.exe' => '/bin/wand.exe'
    end

Build a MSI and install it:

    % rake msi
    % msiexec /i wix\Magic.msi

Dependencies
------------

Packup requires the [WiX Toolset][wix] be installed. If the WIX_HOME environment
variable is set, Packup will look for binaries in a "bin" folder there. If the
toolset can't be found, it will assume the binaries are on your PATH.

License
-------

Packup is available under an [MIT-style][mit] license. See the {file:LICENSE.md} document for more information.

[wix]: http://wixtoolset.org/ "The WiX toolset builds Windows installation packages from XML source code."
[mit]:  http://opensource.org/license/MIT "Open Source Initiative OSI - The MIT License"
