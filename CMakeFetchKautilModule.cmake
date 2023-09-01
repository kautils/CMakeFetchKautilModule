
### static

# force to refetch all the repo within this configure
# this can be used want to update entire repos or erase binaries unexpectedly 
set(CMakeFetchKautilModule.force FALSE) 

macro(CMakeFetchKautilModule prfx)
    
    set(CMakeFetchKautilModule_evacu_m ${m})
    set(m CMakeFetchKautilModule)
    
    cmake_parse_arguments(${prfx} "VERBOSE;FORCE_UPDATE" "GIT;REMOTE;BRANCH;TAG;HASH;DESTINATION" "CMAKE_CONFIGURE_OPTION;CMAKE_BUILD_OPTION;CMAKE_INSTALL_OPTION" ${ARGV})
    list(APPEND ${m}_unsetter_prfx ${prfx}_DESTINATION ${prfx}_FORCE_UPDATE ${prfx}_GIT ${prfx}_REMOTE ${prfx}_TAG ${prfx}_CMAKE_CONFIGURE_OPTION ${prfx}_CMAKE_BUILD_OPTION ${prfx}_CMAKE_INSTALL_OPTION)
    list(APPEND ${m}_unsetter ${m}_uri ${m}_remote ${m}_tag)
    set(${m}_uri ${${prfx}_GIT})
    set(${m}_remote ${${prfx}_REMOTE})
    set(${m}_branch ${${prfx}_BRANCH})
    set(${m}_tag ${${prfx}_TAG})
    set(${m}_hash ${${prfx}_HASH})
    
    list(APPEND ${m}_unsetter ${m}_cmake_configure ${m}_cmake_build ${m}_cmake_install)
    set(${m}_cmake_configure ${${prfx}_CMAKE_CONFIGURE_OPTION})
    set(${m}_cmake_build ${${prfx}_CMAKE_BUILD_OPTION})
    set(${m}_cmake_install ${${prfx}_CMAKE_INSTALL_OPTION})
    
    list(APPEND ${m}_unsetter  ${m}_force_option ${m}_verbose_option ${m}_dest)
    if(${${prfx}_FORCE_UPDATE} OR (DEFINED CMakeFetchKautilModule.force AND ${CMakeFetchKautilModule.force})) 
        set(${m}_force_option FORCE_UPDATE )
    endif()
    
    if(${${prfx}_VERBOSE})
        set(${m}_verbose_option VERBOSE )
        include(CmakePrintHelpers)
        foreach(__var ${${m}_unsetter})
            cmake_print_variables(${__var})
        endforeach()
    endif()
    
    
    set(${m}_dest ${${prfx}_DESTINATION})
    if("${${m}_dest}" STREQUAL "")
        set(${m}_dest ${CMAKE_BINARY_DIR}/CMakeFetchKautilModule)
        file(MAKE_DIRECTORY ${${m}_dest})
    endif()
    
    if(NOT EXISTS ${${m}_dest}/cmake/CMakeGitCloneMinimal.cmake)
        file(DOWNLOAD https://raw.githubusercontent.com/kautils/CMakeGitCloneMinimal/v0.0.1/CMakeGitCloneMinimal.cmake "${${m}_dest}/cmake/CMakeGitCloneMinimal.cmake")
    endif()
    
    include("${${m}_dest}/cmake/CMakeGitCloneMinimal.cmake")
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
    
    set(m CMakeFetchKautilModule)
    list(APPEND ${m}_unsetter __build_cache_var)
    set(__build_cache_var ${${prfx}}/${${m}_branch}${${m}_tag}${${m}_hash})
    if("${${m}_force_option}" STREQUAL "")
        if(DEFINED CACHE{${__build_cache_var}})
            if( (NOT "${${__build_cache_var}_configure_op}" STREQUAL "${${m}_cmake_configure}")
               OR (NOT "${${__build_cache_var}_build_op}" STREQUAL "${${m}_cmake_build}")
               OR (NOT "${${__build_cache_var}_install_op}" STREQUAL "${${m}_cmake_install}")
               OR (NOT "${${__build_cache_var}_dest}" STREQUAL "${${m}_dest}"))
                set(${__build_cache_var}_configure_op "${${m}_cmake_configure}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_build_op "${${m}_cmake_build}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_install_op "${${m}_cmake_install}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_dest "${${m}_dest}" CACHE STRING "" FORCE)
                set(${m}_force_option "FORCE_UPDATE")
            endif()
        endif()
    endif()
    
    
    if((NOT ${${m}_force_option} STREQUAL "") 
            OR (NOT DEFINED CACHE{${__build_cache_var}})
            OR (NOT DEFINED CACHE{${__build_cache_var}}))
        if(EXISTS ${${prfx}}/CMakeLists.txt)
            file(MAKE_DIRECTORY ${${prfx}}/build)
            CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR ${${prfx}} COMMAND cmake -S . -B ${${prfx}}/build -DKAUTIL_THIRD_PARTY_DIR='${KAUTIL_THIRD_PARTY_DIR}' ${${m}_cmake_configure})
            if(DEFINED ${m}_cmake_build)
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR ${${prfx}}/build COMMAND cmake --build . ${${m}_cmake_build}) 
            else()
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR ${${prfx}}/build COMMAND cmake --build . )
            endif()
            if(DEFINED ${m}_cmake_install)
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR ${${prfx}}/build COMMAND cmake --install . ${${m}_cmake_install})
            else()
                CMakeExecuteCommand(execgit ASSERT ${${m}_verbose_option} DIR ${${prfx}}/build COMMAND cmake --install . --prefix "${${m}_dest}")
            endif()
            
            set(${__build_cache_var} TRUE CACHE STRING "cmake build cache (clone_dir/requested_id). generated by ${CMAKE_CURRENT_LIST_DIR}" FORCE)
            file(GLOB mod_paths ${${m}_dest}/lib/cmake/*)
            list(APPEND CMAKE_PREFIX_PATH ${mod_paths})
            list(REMOVE_DUPLICATES  CMAKE_PREFIX_PATH)
        endif()
    endif()

    foreach(__var ${${m}_unsetter})
        unset(${__var})
    endforeach()
    unset(${m}_unsetter)
    foreach(__var ${${m}_unsetter_prfx})
        unset(${__var})
    endforeach()
    
    
    set(m ${CMakeFetchKautilModule_evacu_m})
endmacro()
