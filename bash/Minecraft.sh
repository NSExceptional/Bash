### Minecraft related utilities ###

export MINECRAFT=~/Library/Application\ Support/minecraft

# Makes a map of the current world named "Bored" using config.xml.
# config.xml located at ~/bin/Tectonicus/config.xml
mcmap() {
    wd=~/bin/Tectonicus
    java -jar $wd/Tectonicus*.jar config=$wd/config.xml
}

# Opens the minecraft folder
openmc() {
    open "$MINECRAFT"
}

# Sets up a new version of MCP
# Usage: mcpnew version <eclipse_folder>
mcpnew() {
    mcpn__location=~/Repos/MCP
    mcpn__version=$1
    mcpn__eclipse=$2
    
    # Check dir exists
    if [[ ! -d "$mcpn__location" ]]; then
        echo "MCP directory not found at ~/Repos/MCP"
        exit 0
    fi
    
    # Download server jar
    _mc_downloadServerJar $mcpn__version "$mcpn__location/jars"
    
    # Copy old eclipse workspace
    if [[ "$mcpn__eclipse" ]] && [[ -d "$mcpn__eclipse" ]]; then
        echo "Copying old eclipse workspace..."
        rm -rf "$mcpn__location/eclipse"
        cp -r "$mcpn__eclipse" "$mcpn__location/eclipse"
        echo "Done."
    fi
    
    __maybeUpdateMappings "$mcpn__location"
    __maybeSymlinkZmod
}

# Args: mcp_folder
__maybeUpdateMappings() {
    um__location="$1"
    
    echo "Update mcpbot mappings? [y/n]"
    read ums
    case $ums in
    [yY])
        mcpu "$um__location"
        ;;
    [nN])
        ;;
    *)
        echo "Invalid response"
        __maybeUpdateMappings "$um__location"
        ;;
    esac
}

# No args
__maybeSymlinkZmod() {
    echo "Symlink Zombe Mod source files? [y/n]"
    read ums
    case $ums in
    [yY])
        lmaz
        ;;
    [nN])
        ;;
    *)
        echo "Invalid response"
        __maybeSymlinkZmod
        ;;
    esac
}

# Update the config files of an MCP installation
# Usage: mcpu mcp_folder
mcpu() {
    mcpu__location="$1"
    mcpu__tmp="/tmp/mcpu-tmp-folder"
    
    if [[ ! -d $mcpu__tmp ]]; then
        mkdir $mcpu__tmp
    fi
    
    # Check arg exists
    if [[ ! "$mcpu__location" ]]; then
        echo "Must supply the MCP directory"
        exit 0
    fi
    
    # Check dir exists
    if [[ ! -d "$mcpu__location" ]]; then
        echo "MCP directory not found at the given path"
        exit 0
    fi
    
    # Download files
    echo "Downloading files..."
    wget -O $mcpu__tmp/params  "http://export.mcpbot.bspk.rs/params.csv"
    wget -O $mcpu__tmp/methods "http://export.mcpbot.bspk.rs/methods.csv"
    wget -O $mcpu__tmp/fields  "http://export.mcpbot.bspk.rs/fields.csv"
    
    # Check success
    if [[ -e $mcpu__tmp/params ]]; then
        echo "Updated params.csv"
        mv -f $mcpu__tmp/params "$mcpu__location/conf/params.csv"
    else
        echo "Failed to update params.csv"
    fi
    if [[ -e $mcpu__tmp/methods ]]; then
        echo "Updated methods.csv"
        mv -f $mcpu__tmp/methods "$mcpu__location/conf/methods.csv"
    else
        echo "Failed to update methods.csv"
    fi
    if [[ -e $mcpu__tmp/fields ]]; then
        echo "Updated fields.csv"
        mv -f $mcpu__tmp/fields "$mcpu__location/conf/fields.csv"
    else
        echo "Failed to update fields.csv"
    fi
    
    # Cleanup
    rm -rf $mcpu__tmp
}

# Link Zombe-Modpack/source/zombe
#     to MCP/src/minecraft/zombe,
# and link Zombe-Modpack/source/net/minecraft/**/*.java
#        to /MCP/src/minecraft/net/minecraft/**/*.java
# No args
lmaz() {
    lmaz__mcp=~/Repos/MCP
    lmaz__mcp_src="$lmaz__mcp/src"
    lmaz__zmod_src=~/Repos/Zombe-Modpack/source
    
    lmaz__zmod_mc_src="$lmaz__zmod_src/net/minecraft"
    lmaz__mcp_src_net="$lmaz__mcp_src/minecraft/net/minecraft"
    
    if [[ -d $lmaz__zmod_mc_src ]]; then
        if [[ -d $lmaz__mcp ]]; then
            
            mkdir $lmaz__mcp_src_net
            lma $lmaz__zmod_mc_src
        
            lmaz__zmod="$lmaz__zmod_src/zombe"
            lmaz__mcpzmod="$lmaz__mcp_src/minecraft/zombe"
            if [[ -d $lmaz__zmod ]]; then
                if [[ ! -h $lmaz__mcpzmod ]]; then
                    ln -s $lmaz__zmod $lmaz__mcpzmod
                else
                    echo "$lmaz__zmod is already symlinked to $lmaz__mcpzmod"
                fi
            else
                echo "Zombe mod folder missing at "$lmaz__zmod
            fi
        else
            echo "MCP folder missing at "$lmaz__mcp_src
        fi
    else
        echo "Zombe mod Minecraft source folder missing at "$lmaz__zmod_mc_src
    fi
}

# Args: zmod_mc_source_folder
lma() {
    lma_dir="$1"
    
    if [[ ! "$lma_dir" ]] || [[ ! -d "$lma_dir" ]]; then
        echo "$lma_dir" does not exist
    else
        find $lma_dir -type f | grep \\w+*.java | while read -r var ; do
            lm__moveto=`_path "$var"`
            rm -f "$lm__moveto"
        
            lm_dir=`dirname "$lm__moveto"`
            if [[ ! -d $lm_dir ]]; then
                echo Creating $lm_dir
                mkdir "$lm_dir"
            fi
        
            echo "$var" "->" "$lm__moveto"
            ln -s "$var" "$lm__moveto"
        done
    fi
}

# Convert /Users/tanner/Repos/Zombe-Modpack/source/net/minecraft/foo/bar.java
#                        to .../MCP/src/minecraft/net/minecraft/foo/bar.java
_path() {
    echo $(echo "$1" | sed -E "s/Zombe-Modpack\/source/MCP\/src\/minecraft/")
}

# Downloads minecraft server jar to the given location
# Usage: __func version location
_mc_downloadServerJar() {
    mcds__version=$1
    mcds__jarLocation="$2"
    mcds__outdir=
    
    if [[ ! $mcds__version ]] || [[ ! "$mcds__jarLocation" ]]; then
        echo "Missing arguments to download server"
        exit 0
    else
        mcds__outdir="$mcds__jarLocation/minecraft_server.$mcds__version.jar"
        
        if [[ -e $mcds__outdir ]]; then
            echo "Server jar already exists at"$mcds__outdir
        else
            echo "Downloading minecraft_server."$mcds__version".jar" to "$mcds__jarLocation"
            url="https://s3.amazonaws.com/Minecraft.Download/versions/"$mcds__version"/minecraft_server."$mcds__version".jar"
            wget -O $mcds__outdir $url
    
            if [[ -e $mcds__outdir ]]; then
                echo "Done."
            else
                echo "Failed to download file."
                exit 0
            fi
        fi
    fi
}









