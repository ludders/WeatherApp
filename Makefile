## bootstrap			: XCode 12 knackered Carthage, using script to workaround this in the meantime.
bootstrap:
	$(MAKE) carthage_ddd
	./scripts/carthage_xcode12.sh update --platform iOS --no-use-binaries

## carthage_ddd				: Delete Derived Data for carthage
carthage_ddd:
	rm -rf ~/Library/Caches/org.carthage.CarthageKit/DerivedData
