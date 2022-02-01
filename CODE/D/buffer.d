module pcf.buffer;

// -- IMPORTS

import pcf.component;
import pcf.compression;
import pcf.scalar;
import pcf.stream;
import std.conv: to;

// -- TYPES

class BUFFER
{
    // -- ATTIBUTES

    ulong
        MinimumNaturalValue;
    ushort
        ComponentBitCount;
    ulong
        BitCount;
    ubyte[]
        ByteArray;
    ulong
        ReadBitIndex;

    // -- CONSTRUCTORS

    this(
        )
    {
    }

    // ~~

    this(
        COMPONENT component
        )
    {
        ComponentBitCount = component.BitCount;
    }

    // -- INQUIRIES

    void Write(
        STREAM stream
        )
    {
        stream.WriteNatural64( MinimumNaturalValue );
        stream.WriteNatural16( ComponentBitCount );
        stream.WriteNatural64( BitCount );
        stream.WriteScalarArray( ByteArray );
    }

    // -- OPERATIONS

    void Read(
        STREAM stream
        )
    {
        stream.ReadNatural64( MinimumNaturalValue );
        stream.ReadNatural16( ComponentBitCount );
        stream.ReadNatural64( BitCount );
        stream.ReadScalarArray( ByteArray );

        ReadBitIndex = 0;
    }

    // ~~

    void AddComponentValue(
        COMPONENT component,
        double component_value
        )
    {
        double
            real_value;
        ulong
            bit_index,
            byte_index,
            natural_value;
        ushort
            byte_bit_index;
        SCALAR
            scalar;

        if ( component.Compression == COMPRESSION.None )
        {
            if ( ComponentBitCount == 32 )
            {
                scalar.Real32 = component_value.to!float();

                foreach ( component_byte_index; 0 .. 4 )
                {
                    ByteArray ~= scalar.FourByteArray[ component_byte_index ];
                }
            }
            else if ( ComponentBitCount == 64 )
            {
                scalar.Real64 = component_value;

                foreach ( component_byte_index; 0 .. 8 )
                {
                    ByteArray ~= scalar.EightByteArray[ component_byte_index ];
                }
            }
        }
        else if ( component.Compression == COMPRESSION.Discretization )
        {
            real_value = ( component_value - component.MinimumValue ) * component.OneOverPrecision;
            natural_value = real_value.to!ulong() - MinimumNaturalValue;

            assert(
                real_value >= 0.0
                && ( ComponentBitCount == 64
                     || natural_value < ( 1UL << ComponentBitCount ) )
                );

            foreach ( component_bit_index; 0 .. ComponentBitCount )
            {
                bit_index = BitCount + component_bit_index;
                byte_index = bit_index >> 3;
                byte_bit_index = bit_index & 7;

                if ( byte_index == ByteArray.length )
                {
                    ByteArray ~= 0;
                }

                if ( natural_value & ( 1UL << component_bit_index ) )
                {
                    ByteArray[ byte_index ] |= 1 << byte_bit_index;
                }
            }
        }

        BitCount += ComponentBitCount;
    }

    // ~~

    double GetComponentValue(
        COMPONENT component
        )
    {
        double
            component_value,
            real_value;
        ulong
            bit_index,
            byte_index,
            natural_value;
        ushort
            byte_bit_index;
        SCALAR
            scalar;

        if ( component.Compression == COMPRESSION.None )
        {
            byte_index = ReadBitIndex >> 3;

            if ( ComponentBitCount == 32 )
            {
                foreach ( component_byte_index; 0 .. 4 )
                {
                    scalar.FourByteArray[ component_byte_index ] = ByteArray[ byte_index + component_byte_index ];
                }

                component_value = scalar.Real32;
            }
            else if ( ComponentBitCount == 64 )
            {
                foreach ( component_byte_index; 0 .. 8 )
                {
                    scalar.EightByteArray[ component_byte_index ] = ByteArray[ byte_index + component_byte_index ];
                }

                component_value = scalar.Real64;
            }
        }
        else if ( component.Compression == COMPRESSION.Discretization )
        {
            natural_value = 0;

            foreach ( component_bit_index; 0 .. ComponentBitCount )
            {
                bit_index = ReadBitIndex + component_bit_index;
                byte_index = bit_index >> 3;
                byte_bit_index = bit_index & 7;

                if ( ByteArray[ byte_index ] & ( 1 << byte_bit_index ) )
                {
                    natural_value |= 1UL << component_bit_index;
                }
            }

            real_value = natural_value.to!double();
            component_value = ( real_value * component.Precision ) + component.MinimumValue;
        }

        ReadBitIndex += ComponentBitCount;

        return component_value;
    }
}
