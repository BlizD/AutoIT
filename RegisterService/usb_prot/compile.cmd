@echo off

Utilities\Wrapper\AutoIt3Wrapper.exe /in USBProtect.au3
Utilities\UPX\upx.exe Output\USBProtect.exe --best --no-backup --overlay=copy --compress-exports=1 --compress-resources=0 --strip-relocs=1
