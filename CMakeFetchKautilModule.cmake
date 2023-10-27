### static

# force to refetch all the repo within this configure
# this can be used want to update entire repos or erase binaries unexpectedly 
set(CMakeFetchKautilModule.force FALSE) 

macro(CMakeFetchKautilModule prfx)
    
    
    
    set(CMakeFetchKautilModule_evacu_m ${m})
    set(m CMakeFetchKautilModule)
    
    cmake_parse_arguments(${prfx} "VERBOSE;FORCE_UPDATE;FORCE_BUILD;NON_VERSIONING" "GIT;REMOTE;BRANCH;TAG;HASH;DESTINATION" "CMAKE_CONFIGURE_MACRO;CMAKE_CONFIGURE_OPTION;CMAKE_BUILD_OPTION;CMAKE_INSTALL_OPTION" ${ARGV})
    list(APPEND ${m}_unsetter_prfx ${prfx}_FORCE_BUILD ${prfx}_KEYWORDS_MISSING_VALUES ${prfx}_NON_VERSIONING ${prfx}_DESTINATION  ${prfx}_FORCE_UPDATE ${prfx}_GIT ${prfx}_REMOTE ${prfx}_TAG ${prfx}_CMAKE_CONFIGURE_OPTION ${prfx}_CMAKE_BUILD_OPTION ${prfx}_CMAKE_INSTALL_OPTION)
    list(APPEND ${m}_unsetter ${m}_uri ${m}_remote ${m}_tag ${m}_uri_name)
    set(${m}_uri ${${prfx}_GIT})
    get_filename_component(${m}_uri_name "${${m}_uri}" NAME )
    set(${m}_remote ${${prfx}_REMOTE})
    set(${m}_branch ${${prfx}_BRANCH})
    set(${m}_tag ${${prfx}_TAG})
    set(${m}_hash ${${prfx}_HASH})
    
    list(APPEND ${m}_unsetter ${m}_cmake_macro ${m}_cmake_configure ${m}_cmake_build ${m}_cmake_install)
    set(${m}_cmake_configure ${${prfx}_CMAKE_CONFIGURE_OPTION})
    set(${m}_cmake_macro ${${prfx}_CMAKE_CONFIGURE_MACRO})
    set(${m}_cmake_build ${${prfx}_CMAKE_BUILD_OPTION})
    set(${m}_cmake_install ${${prfx}_CMAKE_INSTALL_OPTION})
    
    list(APPEND ${m}_unsetter  ${m}_force_option ${m}_verbose_option ${m}_force_build)
    if(${${prfx}_FORCE_UPDATE} 
            OR (DEFINED CMakeFetchKautilModule.force AND ${CMakeFetchKautilModule.force})) 
        set(${m}_force_option FORCE_UPDATE )
    endif()
    
    set(${m}_force_build ${${prfx}_FORCE_BUILD})
    
    
    
    
    if(${${prfx}_VERBOSE})
        set(${m}_verbose_option VERBOSE )
        include(CmakePrintHelpers)
        foreach(__var ${${m}_unsetter})
            cmake_print_variables(${__var})
        endforeach()
    endif()
    
    list(APPEND ${m}_unsetter ${m}_dest ${m}_non_ver ${m}_third_party_root)
    if(DEFINED KAUTIL_THIRD_PARTY_DIR)
        set(${m}_third_party_root ${KAUTIL_THIRD_PARTY_DIR})
    else()
        set(${m}_third_party_root ${CMAKE_BINARY_DIR})
    endif()
    set(${m}_non_ver ${${prfx}_NON_VERSIONING})
    set(${m}_dest ${${prfx}_DESTINATION})
    if("${${m}_dest}" STREQUAL "")
        if(${${m}_non_ver})
            if(DEFINED ${m}_branch)
                set(${m}_dest "${${m}_third_party_root}/CMakeFetchKautilModule/non_versioning/${${m}_uri_name}/${${m}_branch}")
            elseif(DEFINED ${m}_tag)
                set(${m}_dest "${${m}_third_party_root}/CMakeFetchKautilModule/non_versioning/${${m}_uri_name}/${${m}_tag}")
            elseif(DEFINED ${m}_hash)
                string(SUBSTRING "${${m}_hash}" 0 7 ${m}_buf_short_hash)
                set(${m}_dest "${${m}_third_party_root}/CMakeFetchKautilModule/non_versioning/${${m}_uri_name}/${${m}_buf_short_hash}")
                unset(${m}_buf_short_hash)
            else()
                message(FATAL_ERROR "any of BRANCH,TAG and HASH is not specified.")
            endif()
        else()
            set(${m}_dest ${${m}_third_party_root}/CMakeFetchKautilModule)
        endif()
        file(MAKE_DIRECTORY ${${m}_dest})
    endif()
    
    list(APPEND ${m}_unsetter ${m}_kautil_cmake_module_dir)
    set(${m}_kautil_cmake_module_dir "${${m}_third_party_root}/kautil_cmake")
    if(NOT EXISTS "${${m}_kautil_cmake_module_dir}/CMakeGitCloneMinimal.cmake")
        file(DOWNLOAD https://raw.githubusercontent.com/kautils/CMakeGitCloneMinimal/v0.0.1/CMakeGitCloneMinimal.cmake "${${m}_kautil_cmake_module_dir}/CMakeGitCloneMinimal.cmake")
    endif()
    include("${${m}_kautil_cmake_module_dir}/CMakeGitCloneMinimal.cmake")
    
    
    
    CMakeGitCloneMinimal( ${prfx} 
            REPOSITORY_REMOTE ${${m}_remote}  
            REPOSITORY_URI ${${m}_uri}
            DESTINATION "${${m}_dest}/repository"
            TAG ${${m}_tag}
            HASH ${${m}_hash}
            BRANCH ${${m}_branch}
            ${${m}_force_option}
            ${${m}_verbose_option}
            )
    
    
    
    # key to struct which has the info of a build such as BUILD_DIR, CLONE_PREFIX, INSTALL_PREFIX. 
    # for example, ${${prfx}.STRUCT_ID}.BUILD_DIR is path to build dir   
    list(APPEND ${m}_unsetter __build_cache_var )
    set(__build_cache_var ${${prfx}}/${${m}_branch}${${m}_tag}${${m}_hash})
    string(MD5 __build_cache_var ${__build_cache_var}) 
    string(MD5 ${prfx}.STRUCT_ID ${__build_cache_var}) 
    
    if("${${m}_force_option}" STREQUAL "")
        if(DEFINED CACHE{${__build_cache_var}})
            if( (NOT "${${__build_cache_var}_configure_op}" STREQUAL "${${m}_cmake_configure}")
               OR (NOT "${${__build_cache_var}_configure_macro_op}" STREQUAL "${${m}_cmake_macro}")
               OR (NOT "${${__build_cache_var}_build_op}" STREQUAL "${${m}_cmake_build}")
               OR (NOT "${${__build_cache_var}_install_op}" STREQUAL "${${m}_cmake_install}")
               OR (NOT "${${__build_cache_var}_dest}" STREQUAL "${${m}_dest}"))
                set(${__build_cache_var}_configure_op "${${m}_cmake_configure}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_configure_macro_op "${${m}_cmake_macro}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_build_op "${${m}_cmake_build}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_install_op "${${m}_cmake_install}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_dest "${${m}_dest}" CACHE STRING "" FORCE)
                set(${m}_force_option "FORCE_UPDATE")
            endif()
        endif()
    endif()
    
    
    
    if(${${m}_force_build}
            OR (NOT ${${m}_force_option} STREQUAL "") 
            OR (NOT DEFINED CACHE{${__build_cache_var}}))
        
        
        if(EXISTS ${${prfx}}/CMakeLists.txt)
            
            list(APPEND ${m}_unsetter ${m}_build_root ${m}_0 ${m}_1 ${m}_build_id ${m}_compiler_hash ${m}_mingw_id)
            get_filename_component(${m}_0 "${${prfx}}" NAME)
            get_filename_component(${m}_1 "${${prfx}}" DIRECTORY)
            get_filename_component(${m}_1 "${${m}_1}" NAME)
            
            if(${MINGW} EQUAL 1)
                set(${m}_mingw_id -mingw)
            endif()
            string(SHA3_256 ${m}_compiler_hash ${CMAKE_CXX_COMPILER}${CMAKE_CXX_COMPILER_RANLIB}${CMAKE_CXX_COMPILER_LAUNCHER})
            string(SUBSTRING ${${m}_compiler_hash} 0 7 ${m}_compiler_hash)
            set(${m}_build_id)
            string(APPEND ${m}_build_id ${CMAKE_CXX_COMPILER_ID}${${m}_mingw_id}-${CMAKE_GENERATOR}-${${m}_compiler_hash})
            string(TOLOWER ${${m}_build_id} ${m}_build_id)
            
            set(${m}_build_root ${${m}_dest}/build/${${m}_1}/${${m}_0}/${${m}_build_id}) # as build cache
            file(MAKE_DIRECTORY ${${m}_build_root}) 
            
            list(APPEND ${m}_unsetter ${m}_str_work_dir ${m}_str_build_dir ${m}_str_generator) 
            # for white space
            string(APPEND ${m}_str_work_dir "${${prfx}}")
            string(APPEND ${m}_str_build_dir "${${m}_build_root}")
            string(APPEND ${m}_str_generator "${CMAKE_GENERATOR}")
            
            
            
            
            if(DEFINED ${m}_cmake_configure)
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR "${${m}_build_root}" COMMAND cmake -S . -B "${${m}_str_build_dir}" ${${m}_cmake_configure} ${${m}_cmake_macro})  
            else()
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR "${${m}_str_work_dir}" COMMAND cmake -S . -B "${${m}_str_build_dir}" -G "${${m}_str_generator}"
                        -DKAUTIL_THIRD_PARTY_DIR='${KAUTIL_THIRD_PARTY_DIR}'
                        -DCMAKE_CXX_COMPILER='${CMAKE_CXX_COMPILER}'
                        -DCMAKE_C_COMPILER='${CMAKE_C_COMPILER}'
                        -DCMAKE_CXX_COMPILER_LAUNCHER='${CMAKE_CXX_COMPILER_LAUNCHER}'
                        -DCMAKE_CXX_COMPILER_RANLIB='${CMAKE_CXX_COMPILER_RANLIB}'
                        ${${m}_cmake_macro}
                        )
            endif()
            if(DEFINED ${m}_cmake_build)
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR "${${m}_build_root}" COMMAND cmake --build . ${${m}_cmake_build}) 
            else()
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR "${${m}_build_root}" COMMAND cmake --build . )
            endif()
            if(DEFINED ${m}_cmake_install)
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR "${${m}_build_root}" COMMAND cmake --install . ${${m}_cmake_install})
            else()
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR "${${m}_build_root}" COMMAND cmake --install . --prefix '${${m}_dest}')
            endif()
            
            set(${__build_cache_var} TRUE CACHE STRING "cmake build cache (clone_dir/requested_id). generated by ${CMAKE_CURRENT_LIST_DIR}" FORCE)
            
            set(${${prfx}.STRUCT_ID}.BUILD_DIR "${${m}_str_build_dir}" CACHE STRING "last cloned dir" FORCE)
            set(${${prfx}.STRUCT_ID}.CLONE_PREFIX "${${prfx}}" CACHE STRING "last cloned dir" FORCE)
            set(${${prfx}.STRUCT_ID}.INSTALL_PREFIX "${${m}_dest}" CACHE STRING "last installed dir" FORCE)
            set(${${prfx}.STRUCT_ID}.VARS "${${prfx}_buf_list}" CACHE STRING "variables struct ${prfx} has." FORCE)
        
            if(EXISTS "${kautil_jvm_info.INSTALL_PREFIX}/lib/cmake")
                list(APPEND CMAKE_PREFIX_PATH "${kautil_jvm_info.INSTALL_PREFIX}/lib/cmake")
                list(REMOVE_DUPLICATES CMAKE_PREFIX_PATH)
            endif()
        endif()
    endif()
    
    
    file(GLOB mod_paths ${${m}_dest}/lib/cmake/*)
    list(APPEND CMAKE_PREFIX_PATH ${mod_paths})
    list(REMOVE_DUPLICATES  CMAKE_PREFIX_PATH)
    
    
    foreach(__var ${${m}_unsetter})
        unset(${__var})
    endforeach()
    unset(${m}_unsetter)
    foreach(__var ${${m}_unsetter_prfx})
        unset(${__var})
    endforeach()
    
    set(m ${CMakeFetchKautilModule_evacu_m})
    
endmacro()
