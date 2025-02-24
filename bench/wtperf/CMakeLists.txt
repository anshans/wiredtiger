#
# Public Domain 2014-present MongoDB, Inc.
# Public Domain 2008-2014 WiredTiger, Inc.
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

project(wtperf C)

set(wt_perf_flags)
if(ENABLE_SNAPPY)
    list(APPEND wt_perf_flags "-DSNAPPY_PATH=\"snappy/libwiredtiger_snappy.so\"")
endif()
if(ENABLE_LZ4)
    list(APPEND wt_perf_flags "-DLZ4_PATH=\"lz4/libwiredtiger_lz4.so\"")
endif()
if(ENABLE_ZLIB)
    list(APPEND wt_perf_flags "-DZLIB_PATH=\"zlib/libwiredtiger_zlib.so\"")
endif()
if(ENABLE_ZSTD)
    list(APPEND wt_perf_flags "-DZSTD_PATH=\"zstd/libwiredtiger_zstd.so\"")
endif()

create_test_executable(wtperf
    SOURCES
        config.c
        idle_table_cycle.c
        misc.c
        track.c
        wtperf.c
        wtperf_throttle.c
        wtperf_truncate.c
    FLAGS
        ${wt_perf_flags}
)

if(WT_POSIX)
    # Need to link math on POSIX systems.
    target_link_libraries(wtperf m)
endif()

# Smoke-test wtperf as part of running "ctest check".
define_test_variants(wtperf
    VARIANTS
        "test_wtperf_small_lsm;-O \"${CMAKE_CURRENT_SOURCE_DIR}/runners/small-lsm.wtperf\" -o \"run_time=20\""
    LABELS
        check
        wtperf
)
