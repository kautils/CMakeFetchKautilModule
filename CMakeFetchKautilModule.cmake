
macro(CMakeFetchKautilModule prfx)
    
    cmake_parse_arguments(${prfx} "VERBOSE;FORCE_UPDATE" "GIT;REMOTE;BRANCH;TAG;HASH;DESTINATION" "CMAKE_CONFIGURE_OPTION;CMAKE_BUILD_OPTION;CMAKE_INSTALL_OPTION" ${ARGV})
    list(APPEND unsetter_prfx ${prfx}_DESTINATION ${prfx}_FORCE_UPDATE ${prfx}_GIT ${prfx}_REMOTE ${prfx}_TAG ${prfx}_CMAKE_CONFIGURE_OPTION ${prfx}_CMAKE_BUILD_OPTION ${prfx}_CMAKE_INSTALL_OPTION)
    list(APPEND unsetter __uri __remote __tag)
    set(__uri ${${prfx}_GIT})
    set(__remote ${${prfx}_REMOTE})
    set(__branch ${${prfx}_BRANCH})
    set(__tag ${${prfx}_TAG})
    set(__hash ${${prfx}_HASH})
    
    list(APPEND unsetter __cmake_configure __cmake_build __cmake_install)
    set(__cmake_configure ${${prfx}_CMAKE_CONFIGURE_OPTION})
    set(__cmake_build ${${prfx}_CMAKE_BUILD_OPTION})
    set(__cmake_install ${${prfx}_CMAKE_INSTALL_OPTION})
    
    list(APPEND unsetter_cache  __force_option __verbose_option __dest)
    if(${${prfx}_FORCE_UPDATE}) 
        set(__force_option FORCE_UPDATE CACHE STRING "")
    endif()
    
    if(${${prfx}_VERBOSE})
        set(__verbose_option VERBOSE CACHE STRING "")
        include(CmakePrintHelpers)
        foreach(__var ${unsetter})
            cmake_print_variables(${__var})
        endforeach()
    endif()
    
    
    set(__dest ${${prfx}_DESTINATION} CACHE STRING "")
    if("${__dest}" STREQUAL "")
        set(__dest ${CMAKE_BINARY_DIR}/CMakeFetchKautilModule)
        file(MAKE_DIRECTORY ${__dest})
    endif()
    
         
    if(NOT EXISTS ${__dest}/cmake/CMakeGitCloneMinimal.cmake)
        file(DOWNLOAD https://raw.githubusercontent.com/kautils/CMakeGitCloneMinimal/v0.0.1/CMakeGitCloneMinimal.cmake "${__dest}/cmake/CMakeGitCloneMinimal.cmake")
    endif()
    
    include("${__dest}/cmake/CMakeGitCloneMinimal.cmake")
    
    
    CMakeGitCloneMinimal( ${prfx} 
            REPOSITORY_REMOTE ${__remote}  
            REPOSITORY_URI ${__uri}
            DESTINATION "${__dest}/repository"
            TAG ${__tag}
            HASH ${__hash}
            BRANCH ${__branch}
            ${__force_option}
            ${__verbose_option}
            )
    
    
    list(APPEND unsetter __build_cache_var)
    set(__build_cache_var ${${prfx}}/${__branch}${__tag}${__hash})
    if("${__force_option}" STREQUAL "")
        if(DEFINED CACHE{${__build_cache_var}})
            if( (NOT "${${__build_cache_var}_configure_op}" STREQUAL "${__cmake_configure}")
               OR (NOT "${${__build_cache_var}_build_op}" STREQUAL "${__cmake_build}")
               OR (NOT "${${__build_cache_var}_install_op}" STREQUAL "${__cmake_install}")
               OR (NOT "${${__build_cache_var}_dest}" STREQUAL "${__dest}"))
                set(${__build_cache_var}_configure_op "${__cmake_configure}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_build_op "${__cmake_build}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_install_op "${__cmake_install}" CACHE STRING "" FORCE)
                set(${__build_cache_var}_dest "${__dest}" CACHE STRING "" FORCE)
                set(__force_option "FORCE_UPDATE")
            endif()
        endif()
    endif()
    
    
    
    if((NOT ${__force_option} STREQUAL "") OR (NOT DEFINED CACHE{${__build_cache_var}}))
        if(EXISTS ${${prfx}}/CMakeLists.txt)
            file(MAKE_DIRECTORY ${${prfx}}/build)
            CMakeExecuteCommand(execgit ASSERT ${__verbose_option} DIR ${${prfx}} COMMAND cmake -S . -B ${${prfx}}/build -D__dest='${__dest}' ${__cmake_configure})
            if(DEFINED __cmake_build)
                CMakeExecuteCommand(execgit ASSERT ${__verbose_option} DIR ${${prfx}} COMMAND cmake --build ${${prfx}}/build  ${__cmake_build})
            else()
                CMakeExecuteCommand(execgit ASSERT ${__verbose_option} DIR ${${prfx}} COMMAND cmake --build ${${prfx}}/build)
            endif()
            if(DEFINED __cmake_install)
                CMakeExecuteCommand(execgit ASSERT ${__verbose_option} DIR ${${prfx}} COMMAND cmake --install ${${prfx}}/build ${__cmake_install})
            else()
                CMakeExecuteCommand(execgit ASSERT ${__verbose_option} DIR ${${prfx}} COMMAND cmake --install ${${prfx}}/build --prefix ${__dest})
            endif()
            
            set(${__build_cache_var} TRUE CACHE STRING "cmake build cache (clone_dir/requested_id). generated by ${CMAKE_CURRENT_LIST_DIR}" FORCE)
            file(GLOB mod_paths ${__dest}/lib/cmake/*)
            list(APPEND CMAKE_PREFIX_PATH ${mod_paths})
            list(REMOVE_DUPLICATES  CMAKE_PREFIX_PATH)
        endif()
    endif()

    foreach(__var ${unsetter})
        unset(${__var})
    endforeach()
    unset(unsetter)
    foreach(__var ${unsetter_prfx})
        unset(${__var})
    endforeach()
    foreach(__var ${unsetter_cache})
        unset(${__var} CACHE)
    endforeach()
    
    unset(unsetter_cache)
endmacro()
