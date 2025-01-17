set(MIN_OpenImageDenoise_VERSION "2.0")


include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
include(../cmake/CheckGit.cmake)
set(INSTALL_LOCAL_CONFIGDIR "${CMAKE_BINARY_DIR}/cmake")
set(INSTALL_CONFIGDIR "${CMAKE_INSTALL_LIBDIR}/cmake/Crucible")

if (CRUCIBLE_DYNAMIC_LIBRARY)
	set(CRUCIBLE_LIBRARY_TYPE SHARED)
	message(STATUS "Building Crucible as a shared library")
else()
	set(CRUCIBLE_LIBRARY_TYPE STATIC)
	message(STATUS "Crucible as a static library")
endif()

if(CRUCIBLE_NIGHTLY_VERSIONING)
message(STATUS "Nightly versioning scheme enabled")
CheckGitSetup()
add_compile_definitions(CRUCIBLE_NIGHTLY=1)
endif()

add_subdirectory(BULLET)
add_subdirectory(Utility)

set(HEADER_FILES
		WickedEngine.h
		CommonInclude.h
		logo.h
		sdl2.h
		wiApplication.h
		wiApplication_BindLua.h
		wiArchive.h
		wiArguments.h
		wiAudio.h
		wiAudio_BindLua.h
		wiBacklog.h
		wiBacklog_BindLua.h
		wiCanvas.h
		wiColor.h
		wiECS.h
		wiEmittedParticle.h
		wiEnums.h
		wiEventHandler.h
		wiFadeManager.h
		wiFFTGenerator.h
		wiFont.h
		wiGPUBVH.h
		wiGPUSortLib.h
		wiGraphics.h
		wiGraphicsDevice.h
		wiGraphicsDevice_DX12.h
		wiGraphicsDevice_Vulkan.h
		wiGUI.h
		wiHairParticle.h
		wiHelper.h
		wiImage.h
		wiImageParams_BindLua.h
		wiInitializer.h
		wiInput.h
		wiInput_BindLua.h
		wiJobSystem.h
		wiLoadingScreen.h
		wiLoadingScreen_BindLua.h
		wiLua.h
		wiLua_Globals.h
		wiLuna.h
		wiMath.h
		wiMath_BindLua.h
		wiNetwork.h
		wiNetwork_BindLua.h
		wiNoise.h
		wiOcean.h
		wiPhysics.h
		wiPhysics_BindLua.h
		wiPlatform.h
		wiPrimitive.h
		wiPrimitive_BindLua.h
		wiProfiler.h
		wiRandom.h
		wiRawInput.h
		wiRectPacker.h
		wiRenderer.h
		wiRenderer_BindLua.h
		wiRenderPath.h
		wiRenderPath2D.h
		wiRenderPath2D_BindLua.h
		wiRenderPath3D.h
		wiRenderPath3D_BindLua.h
		wiRenderPath3D_PathTracing.h
		wiRenderPath_BindLua.h
		wiResourceManager.h
		wiScene.h
		wiScene_BindLua.h
		wiScene_Decl.h
		wiScene_Components.h
		wiSDLInput.h
		wiShaderCompiler.h
		wiSheenLUT.h
		wiSpinLock.h
		wiSprite.h
		wiSprite_BindLua.h
		wiSpriteAnim_BindLua.h
		wiSpriteFont.h
		wiSpriteFont_BindLua.h
		wiTexture_BindLua.h
		wiTextureHelper.h
		wiTimer.h
		wiUnorderedMap.h
		wiUnorderedSet.h
		wiVector.h
		wiVersion.h
		wiXInput.h
		wiConfig.h
		wiTerrain.h
		wiAllocator.h
		wiBVH.h
		wiLocalization.h
		wiVideo.h
		wiKeyValue.h
		)

add_library(Crucible ${CRUCIBLE_LIBRARY_TYPE}
	$<$<PLATFORM_ID:Windows>:
		wickedengine.natvis
	>
	wiLoadingScreen.cpp
	wiLoadingScreen_BindLua.cpp
	wiApplication.cpp
	wiApplication_BindLua.cpp
	wiRenderPath_BindLua.cpp
	wiRenderPath2D.cpp
	wiRenderPath2D_BindLua.cpp
	wiRenderPath3D.cpp
	wiRenderPath3D_BindLua.cpp
	wiRenderPath3D_PathTracing.cpp
	wiSpriteAnim_BindLua.cpp
	wiTexture_BindLua.cpp
	wiMath_BindLua.cpp
	wiArchive.cpp
	wiAudio.cpp
	wiAudio_BindLua.cpp
	wiBacklog.cpp
	wiBacklog_BindLua.cpp
	wiEmittedParticle.cpp
	wiEventHandler.cpp
	wiFadeManager.cpp
	wiFFTGenerator.cpp
	wiFont.cpp
	wiGPUBVH.cpp
	wiGPUSortLib.cpp
	wiGraphicsDevice_DX12.cpp
	wiGraphicsDevice_Vulkan.cpp
	wiGUI.cpp
	wiHairParticle.cpp
	wiHelper.cpp
	wiImage.cpp
	wiImageParams_BindLua.cpp
	wiInitializer.cpp
	wiInput.cpp
	wiInput_BindLua.cpp
	wiPrimitive.cpp
	wiPrimitive_BindLua.cpp
	wiJobSystem.cpp
	wiLua.cpp
	wiMath.cpp
	wiNetwork_BindLua.cpp
	wiNetwork_Linux.cpp
	wiNetwork_Windows.cpp
	wiNetwork_UWP.cpp
	wiOcean.cpp
	wiPhysics_Bullet.cpp
	wiPhysics_BindLua.cpp
	wiProfiler.cpp
	wiRandom.cpp
	wiRawInput.cpp
	wiRenderer.cpp
	wiRenderer_BindLua.cpp
	wiResourceManager.cpp
	wiScene.cpp
	wiScene_Components.cpp
	wiScene_BindLua.cpp
	wiScene_Serializers.cpp
	wiSDLInput.cpp
	wiSprite.cpp
	wiSprite_BindLua.cpp
	wiSpriteFont.cpp
	wiSpriteFont_BindLua.cpp
	wiArguments.cpp
	wiTextureHelper.cpp
	wiVersion.cpp
	wiXInput.cpp
	wiShaderCompiler.cpp
	wiConfig.cpp
	wiTerrain.cpp
	wiLocalization.cpp
	wiVideo.cpp
	wiKeyValue.cpp
	${HEADER_FILES}
)

set_target_properties(Crucible PROPERTIES PUBLIC_HEADER "${HEADER_FILES}")

target_include_directories(Crucible SYSTEM PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
	$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/Crucible>
)

set(CRUCIBLE_STATIC_LIBRARIES
	Bullet
	Utility
)

if(CRUCIBLE_NIGHTLY_VERSIONING)
set(CRUCIBLE_STATIC_LIBRARIES ${CRUCIBLE_STATIC_LIBRARIES} cmake_genvars)
endif()

if (WIN32)
	target_compile_definitions(Crucible PUBLIC
		UNICODE _UNICODE
	)

	target_compile_options(Crucible PRIVATE /W3 $<$<CONFIG:Debug>:/bigobj>)
	
	target_link_options(Crucible PRIVATE /NATVIS:${CMAKE_CURRENT_SOURCE_DIR}/wickedengine.natvis)

	set(LIBDXCOMPILER "dxcompiler.dll")
else ()
	# `ska::flat_hash_map` has issues on linux because of the hash function being identity
	# in same cases. Use `robin_hood::unordered_flat_map` instead
	target_compile_definitions(Crucible PUBLIC WI_UNORDERED_MAP_TYPE=2)

	target_link_libraries(Crucible PUBLIC
		Threads::Threads
		SDL2::SDL2
		${LUA_LIBRARIES}
		$<$<BOOL:${OpenImageDenoise_FOUND}>:OpenImageDenoise> # links OpenImageDenoise only if it's found
	)
	set(CRUCIBLE_STATIC_LIBRARIES ${CRUCIBLE_STATIC_LIBRARIES} FAudio)

	# add some warnings and set them as errors
	# read more details here: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
	target_compile_options(Crucible PRIVATE
			-Wuninitialized
			-Wmaybe-uninitialized
			-Wwrite-strings
			-Winit-self
			-Wreturn-type
			-Wreorder
			-Werror=delete-non-virtual-dtor
			-Werror
			#uncomment this to stop the compilation at the first error
			# -Wfatal-errors
			)

	target_link_libraries(Crucible PRIVATE dl)

	set(LIBDXCOMPILER "libdxcompiler.so")
endif()

target_link_libraries(Crucible PUBLIC ${CRUCIBLE_STATIC_LIBRARIES})

if (PLATFORM MATCHES "SDL2")
	target_compile_definitions(Crucible PUBLIC SDL2=1)
endif()

add_library(dxcompiler SHARED IMPORTED)
set_property(TARGET dxcompiler PROPERTY
		IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/Crucible/${LIBDXCOMPILER} )

# Copy the shader library next to the executable
add_custom_command(
		TARGET Crucible POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/Crucible/${LIBDXCOMPILER} ${CMAKE_CURRENT_BINARY_DIR}
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/Crucible/shaders ${CMAKE_CURRENT_BINARY_DIR}/shaders
)

# OFFLINE SHADER COMPILER
add_executable(offlineshadercompiler
		offlineshadercompiler.cpp
)

target_link_libraries(offlineshadercompiler
		PUBLIC Crucible ${LUA_LIBRARIES})

install(TARGETS offlineshadercompiler
		RUNTIME DESTINATION "${CMAKE_INSTALL_LIBDIR}/Crucible")

install(DIRECTORY "${CMAKE_SOURCE_DIR}/Content"
		DESTINATION "${CMAKE_INSTALL_LIBDIR}/Crucible")

#### LOCAL FOLDER INSTALLATION
# Create importable target here

#set_target_properties(${TARGET_NAME} PROPERTIES PUBLIC_HEADER "${HEADERS}")
#set_target_properties("${TARGET_NAME}" PROPERTIES EXPORT_NAME "${TARGET_NAME}")


install(TARGETS "Crucible" ${CRUCIBLE_STATIC_LIBRARIES}
		EXPORT Engine-Targets
		LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
		ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/Crucible"
		PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/Crucible")

install(FILES ${LIBDXCOMPILER}
		DESTINATION "${CMAKE_INSTALL_LIBDIR}/Crucible")

export(EXPORT Engine-Targets
		FILE "${CMAKE_BINARY_DIR}/cmake/CrucibleTargets.cmake"
		NAMESPACE Crucible::
		)

install(EXPORT Engine-Targets
		FILE CrucibleTargets.cmake
		NAMESPACE Crucible::
		DESTINATION ${INSTALL_CONFIGDIR})

set(_CONFIG_INSTALL_DIR_INCLUDE "${CMAKE_SOURCE_DIR}")
set(_CONFIG_INSTALL_DIR_LIB "${CMAKE_SOURCE_DIR}")
configure_package_config_file(
		${CMAKE_CURRENT_SOURCE_DIR}/CrucibleConfig.cmake.in
		${CMAKE_BINARY_DIR}/cmake/CrucibleConfig.cmake
		INSTALL_DESTINATION ${INSTALL_LOCAL_CONFIGDIR}
)
set(_CONFIG_INSTALL_DIR_INCLUDE "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_INCLUDEDIR}")
set(_CONFIG_INSTALL_DIR_LIB "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
configure_package_config_file(
		${CMAKE_CURRENT_SOURCE_DIR}/CrucibleConfig.cmake.in
		${CMAKE_BINARY_DIR}/cmake/install/CrucibleConfig.cmake
		INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
)

install(FILES ${CMAKE_BINARY_DIR}/cmake/install/CrucibleConfig.cmake
		DESTINATION ${INSTALL_CONFIGDIR}
)

# Shaders
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/shaders
		DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/Crucible"
		PATTERN "spirv" EXCLUDE
		PATTERN "hlsl6" EXCLUDE
		PATTERN "*.vcxitems*" EXCLUDE
		)
