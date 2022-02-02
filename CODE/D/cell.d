module pcf.cell;

// -- IMPORTS

import pcf.component;
import pcf.buffer;
import pcf.stream;
import pcf.vector_3;
import std.container.array;
import std.container.util;

// -- TYPES

class CELL
{
    // -- ATTRIBUTES

    ulong
        PointCount;
    VECTOR_3
        PositionVector;
    BUFFER[]
        BufferArray;
    static void delegate( CELL )
        PreWriteDelegate,
        PostWriteDelegate,
        PreReadDelegate,
        PostReadDelegate;

    // -- CONSTRUCTORS

    this(
        )
    {
    }

    // ~~

    this(
        COMPONENT[] component_array
        )
    {
        foreach ( component; component_array )
        {
            BufferArray ~= new BUFFER( component );
        }
    }

    // -- INQUIRIES

    void Write(
        STREAM stream
        )
    {
        if ( PreWriteDelegate !is null )
        {
            PreWriteDelegate( this );
        }

        stream.WriteNatural64( PointCount );
        stream.WriteValue( PositionVector );
        stream.WriteObjectArray( BufferArray );

        if ( PostWriteDelegate !is null )
        {
            PostWriteDelegate( this );
        }
    }

    // -- OPERATIONS

    void Clear(
        )
    {
        BufferArray.destroy();
    }

    // ~~

    void Read(
        STREAM stream
        )
    {
        if ( PreReadDelegate !is null )
        {
            PreReadDelegate( this );
        }

        stream.ReadNatural64( PointCount );
        stream.ReadValue( PositionVector );
        stream.ReadObjectArray( BufferArray );

        if ( PostReadDelegate !is null )
        {
            PostReadDelegate( this );
        }
    }

    // ~~

    void SeekComponent(
        ulong component_index
        )
    {
        assert( component_index == 0 );

        foreach ( buffer; BufferArray )
        {
            buffer.ReadBitIndex = 0;
        }
    }

    // ~~

    void AddComponentValue(
        COMPONENT[] component_array,
        ulong component_index,
        double component_value
        )
    {
        if ( component_index == 0 )
        {
            component_value -= PositionVector.X;
        }
        else if ( component_index == 1 )
        {
            component_value -= PositionVector.Y;
        }
        else if ( component_index == 2 )
        {
            component_value -= PositionVector.Z;
        }

        BufferArray[ component_index ].AddComponentValue( component_array[ component_index ], component_value );
    }

    // ~~

    double GetComponentValue(
        COMPONENT[] component_array,
        ulong component_index
        )
    {
        double
            component_value;

        component_value = BufferArray[ component_index ].GetComponentValue( component_array[ component_index ] );

        if ( component_index == 0 )
        {
            component_value += PositionVector.X;
        }
        else if ( component_index == 1 )
        {
            component_value += PositionVector.Y;
        }
        else if ( component_index == 2 )
        {
            component_value += PositionVector.Z;
        }

        return component_value;
    }
}
