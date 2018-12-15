include(vcpkg_common_functions)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO rosenqui/avro
  REF dc98fd3a5e0a342fc1471a703ac9abe746c55118
  SHA512 22d84717b995e6ff30fc7f8756ca4542410c0ac1f8ca0c9929495c81555ce28daa359b20fa4ed9bc85f77c8609b7ee5aecb10d8bc04123c82506d13226f5e314
  HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/avro-cpp.patch)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/lang/c++
    PREFER_NINJA
    OPTIONS
        -DCMAKE_DEBUG_POSTFIX=_d
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/lang/c++/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/avro-cpp RENAME copyright)

vcpkg_copy_pdbs()

# Install EXEs to the tools folder
file(GLOB EXES
        ${CURRENT_PACKAGES_DIR}/bin/avrogencpp.exe
    )
file(COPY ${EXES} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/avro-cpp)
# Tools require dlls
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/avro-cpp)
# Remove the EXEs from the bin folders
file(GLOB TO_REMOVE
        ${CURRENT_PACKAGES_DIR}/bin/avrogencpp.exe
        ${CURRENT_PACKAGES_DIR}/debug/bin/avrogencpp.exe)
file(REMOVE ${TO_REMOVE})

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/avrocpp_s.lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/avrocpp_s_d.lib)
