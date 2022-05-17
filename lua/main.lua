loadfile('lua/package.luac')()
loadfile('lua/lib/string.lua')()

require('file')
require('config')
local http = require('socket.http')
local protect = require('protection')

function getAppData()
    local f = io.popen([[echo %appdata%]])

    if f then
        local read = f:read()

        f:close()

        return read
    end
end

function startGame(name)
    local str = string.gsub(
    [[
        start "" javaw.exe -XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump "-Dos.name=Windows 10" -Dos.version=10.0 -Xss1M -Djava.library.path=javaLibraries -Dminecraft.launcher.brand=minecraft-launcher -Dminecraft.launcher.version=2.2.8545 -cp libraries\net\fabricmc\tiny-mappings-parser\0.3.0+build.17\tiny-mappings-parser-0.3.0+build.17.jar;libraries\net\fabricmc\sponge-mixin\0.10.7+mixin.0.8.4\sponge-mixin-0.10.7+mixin.0.8.4.jar;libraries\net\fabricmc\tiny-remapper\0.6.0\tiny-remapper-0.6.0.jar;libraries\net\fabricmc\access-widener\2.0.1\access-widener-2.0.1.jar;libraries\org\ow2\asm\asm\9.2\asm-9.2.jar;libraries\org\ow2\asm\asm-analysis\9.2\asm-analysis-9.2.jar;libraries\org\ow2\asm\asm-commons\9.2\asm-commons-9.2.jar;libraries\org\ow2\asm\asm-tree\9.2\asm-tree-9.2.jar;libraries\org\ow2\asm\asm-util\9.2\asm-util-9.2.jar;libraries\net\fabricmc\intermediary\1.18.1\intermediary-1.18.1.jar;libraries\net\fabricmc\fabric-loader\0.12.12\fabric-loader-0.12.12.jar;libraries\com\mojang\blocklist\1.0.6\blocklist-1.0.6.jar;libraries\com\mojang\patchy\2.1.6\patchy-2.1.6.jar;libraries\com\github\oshi\oshi-core\5.8.2\oshi-core-5.8.2.jar;libraries\net\java\dev\jna\jna\5.9.0\jna-5.9.0.jar;libraries\net\java\dev\jna\jna-platform\5.9.0\jna-platform-5.9.0.jar;libraries\org\slf4j\slf4j-api\1.8.0-beta4\slf4j-api-1.8.0-beta4.jar;libraries\org\apache\logging\log4j\log4j-slf4j18-impl\2.14.1\log4j-slf4j18-impl-2.14.1.jar;libraries\com\ibm\icu\icu4j\69.1\icu4j-69.1.jar;libraries\com\mojang\javabridge\1.2.24\javabridge-1.2.24.jar;libraries\net\sf\jopt-simple\jopt-simple\5.0.4\jopt-simple-5.0.4.jar;libraries\io\netty\netty-all\4.1.68.Final\netty-all-4.1.68.Final.jar;libraries\com\google\guava\failureaccess\1.0.1\failureaccess-1.0.1.jar;libraries\com\google\guava\guava\31.0.1-jre\guava-31.0.1-jre.jar;libraries\org\apache\commons\commons-lang3\3.12.0\commons-lang3-3.12.0.jar;libraries\commons-io\commons-io\2.11.0\commons-io-2.11.0.jar;libraries\commons-codec\commons-codec\1.15\commons-codec-1.15.jar;libraries\com\mojang\brigadier\1.0.18\brigadier-1.0.18.jar;libraries\com\mojang\datafixerupper\4.0.26\datafixerupper-4.0.26.jar;libraries\com\google\code\gson\gson\2.8.8\gson-2.8.8.jar;libraries\com\mojang\authlib\3.2.38\authlib-3.2.38.jar;libraries\org\apache\commons\commons-compress\1.21\commons-compress-1.21.jar;libraries\org\apache\httpcomponents\httpclient\4.5.13\httpclient-4.5.13.jar;libraries\commons-logging\commons-logging\1.2\commons-logging-1.2.jar;libraries\org\apache\httpcomponents\httpcore\4.4.14\httpcore-4.4.14.jar;libraries\it\unimi\dsi\fastutil\8.5.6\fastutil-8.5.6.jar;libraries\org\apache\logging\log4j\log4j-api\2.14.1\log4j-api-2.14.1.jar;libraries\org\apache\logging\log4j\log4j-core\2.14.1\log4j-core-2.14.1.jar;libraries\org\lwjgl\lwjgl\3.2.2\lwjgl-3.2.2.jar;libraries\org\lwjgl\lwjgl-jemalloc\3.2.2\lwjgl-jemalloc-3.2.2.jar;libraries\org\lwjgl\lwjgl-openal\3.2.2\lwjgl-openal-3.2.2.jar;libraries\org\lwjgl\lwjgl-opengl\3.2.2\lwjgl-opengl-3.2.2.jar;libraries\org\lwjgl\lwjgl-glfw\3.2.2\lwjgl-glfw-3.2.2.jar;libraries\org\lwjgl\lwjgl-stb\3.2.2\lwjgl-stb-3.2.2.jar;libraries\org\lwjgl\lwjgl-tinyfd\3.2.2\lwjgl-tinyfd-3.2.2.jar;libraries\com\mojang\text2speech\1.11.3\text2speech-1.11.3.jar;versions\fabric-loader-0.12.12-1.18.1\fabric-loader-0.12.12-1.18.1.jar "-DFabricMcEmu= net.minecraft.client.main.Main " -Xmx2G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -Dlog4j.configurationFile=assets\log_configs\client-1.12.xml net.fabricmc.loader.impl.launch.knot.KnotClient --username !NICKNAME! --version fabric-loader-0.12.12-1.18.1 --gameDir game --assetsDir assets --assetIndex 1.18 --userType msa --versionType release
    ]],
        '!APPDATA!', AppData
    )

    str = string.gsub(str, '!NICKNAME!', name)
    
    os.execute(str)
end

AppData = getAppData()

CFG.check()
protect.checkMods()
protect.checkResourcepacks()
startGame(CFG.user.name or 'Player')

math.randomseed(os.time())
if math.random() <= 0.01 then 
    io.popen([[explorer "https://www.youtube.com/watch?v=dQw4w9WgXcQ"]])
end