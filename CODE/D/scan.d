module pcf.scan;

// -- IMPORTS

import pcf.cell;
import pcf.cell_position_vector;
import pcf.component;
import pcf.compression;
import pcf.image;
import pcf.property;
import pcf.stream;
import pcf.vector_3;
import pcf.vector_4;

// -- TYPES

class SCAN
{
    // -- ATTRIBUTES

    string
        Name;
    ulong
        ColumnCount,
        RowCount,
        PointCount;
    VECTOR_3
        PositionVector;
    VECTOR_4
        RotationVector;
    VECTOR_3
        XAxisVector,
        YAxisVector,
        ZAxisVector;
    PROPERTY[]
        PropertyArray;
    IMAGE[]
        ImageArray;
    CELL[ CELL_POSITION_VECTOR ]
        CellMap;
    static void function( SCAN )
        PreWriteFunction,
        PostWriteFunction,
        PreReadFunction,
        PostReadFunction;
    static void delegate( SCAN )
        PreWriteDelegate,
        PostWriteDelegate,
        PreReadDelegate,
        PostReadDelegate;

    // -- INQUIRIES

    void Write(
        STREAM stream
        )
    {
        if ( PreWriteFunction !is null )
        {
            PreWriteFunction( this );
        }

        if ( PreWriteDelegate !is null )
        {
            PreWriteDelegate( this );
        }

        stream.WriteText( Name );
        stream.WriteNatural64( ColumnCount );
        stream.WriteNatural64( RowCount );
        stream.WriteNatural64( PointCount );
        stream.WriteValue( PositionVector );
        stream.WriteValue( RotationVector );
        stream.WriteValue( XAxisVector );
        stream.WriteValue( YAxisVector );
        stream.WriteValue( ZAxisVector );
        stream.WriteObjectArray( PropertyArray );
        stream.WriteObjectArray( ImageArray );
        stream.WriteObjectByValueMap( CellMap );

        if ( PostWriteFunction !is null )
        {
            PostWriteFunction( this );
        }

        if ( PostWriteDelegate !is null )
        {
            PostWriteDelegate( this );
        }
    }

    // -- CONSTRUCTORS

    this(
        )
    {
        PositionVector.SetVector( 0.0, 0.0, 0.0 );
        RotationVector.SetVector( 0.0, 0.0, 0.0, 1.0 );
        XAxisVector.SetVector( 1.0, 0.0, 0.0 );
        YAxisVector.SetVector( 0.0, 1.0, 0.0 );
        ZAxisVector.SetVector( 0.0, 0.0, 1.0 );
    }

    // -- OPERATIONS

    void Clear(
        )
    {
        PropertyArray.destroy();
        ImageArray.destroy();
        CellMap.destroy();
    }

    // ~~

    void Read(
        STREAM stream
        )
    {
        if ( PreReadFunction !is null )
        {
            PreReadFunction( this );
        }

        if ( PreReadDelegate !is null )
        {
            PreReadDelegate( this );
        }

        stream.ReadText( Name );
        stream.ReadNatural64( ColumnCount );
        stream.ReadNatural64( RowCount );
        stream.ReadNatural64( PointCount );
        stream.ReadValue( PositionVector );
        stream.ReadValue( RotationVector );
        stream.ReadValue( XAxisVector );
        stream.ReadValue( YAxisVector );
        stream.ReadValue( ZAxisVector );
        stream.ReadObjectArray( PropertyArray );
        stream.ReadObjectArray( ImageArray );
        stream.ReadObjectByValueMap( CellMap );

        if ( PostReadFunction !is null )
        {
            PostReadFunction( this );
        }

        if ( PostReadDelegate !is null )
        {
            PostReadDelegate( this );
        }
    }

    // ~~

    void SetAxisVectors(
        )
    {
         RotationVector.GetAxisVectors( XAxisVector, YAxisVector, ZAxisVector );
    }

    // ~~

    CELL GetCell(
        COMPONENT[] component_array,
        double position_x,
        double position_y,
        double position_z
        )
    {
        CELL
            cell;
        CELL
            * found_cell;
        CELL_POSITION_VECTOR
            cell_position_vector;

        if ( component_array[ 0 ].Compression == COMPRESSION.None )
        {
            assert(
                component_array[ 1 ].Compression == COMPRESSION.None
                && component_array[ 2 ].Compression == COMPRESSION.None
                );

            cell_position_vector.SetVector( 0, 0, 0 );
        }
        else
        {
            assert(
                component_array[ 0 ].Compression == COMPRESSION.Discretization
                && component_array[ 1 ].Compression == COMPRESSION.Discretization
                && component_array[ 2 ].Compression == COMPRESSION.Discretization
                );

            cell_position_vector.SetVector(
                component_array[ 0 ].GetIntegerValue( position_x ) >> component_array[ 0 ].BitCount,
                component_array[ 1 ].GetIntegerValue( position_y ) >> component_array[ 1 ].BitCount,
                component_array[ 2 ].GetIntegerValue( position_z ) >> component_array[ 2 ].BitCount
                );
        }

        found_cell = cell_position_vector in CellMap;

        if ( found_cell !is null )
        {
            assert( found_cell.PositionVector == cell_position_vector );

            return *found_cell;
        }
        else
        {
            cell = new CELL( component_array );
            cell.PositionVector = cell_position_vector;

            CellMap[ cell_position_vector ] = cell;

            return cell;
        }
    }
}
