#pragma once

// -- IMPORTS

#include <map>
using namespace std;

// -- TYPES

namespace pcf
{
    template <typename _KEY_, typename _ELEMENT_>
    struct MAP_ :
        public map<_KEY_, _ELEMENT_>
    {
    };
}
