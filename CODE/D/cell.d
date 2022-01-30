module pcf.cell;

// -- IMPORTS

import pcf.component;
import pcf.file;
import pcf.buffer;
import pcf.vector_3;

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
        FILE file
        )
    {
        file.WriteNatural( PointCount );
        file.WriteValue( PositionVector );
        file.WriteObjectArray( BufferArray );
    }

    // -- OPERATIONS

    void Read(
        FILE file
        )
    {
        file.ReadNatural( PointCount );
        file.ReadValue( PositionVector );
        file.ReadObjectArray( BufferArray );
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

    // ~~

    void Compress(
        COMPONENT[] component_array
        )
    {
        foreach ( buffer_index, buffer; BufferArray )
        {
            buffer.Compress( component_array[ buffer_index ], PointCount );
        }
    }
}
