module pcf.cloud;

// -- IMPORTS

import std.conv : to;
import std.stdio : writeln;
import std.string : strip;
import base.stream;
import base.vector_3;
import pcf.cell;
import pcf.component;
import pcf.compression;
import pcf.property;
import pcf.scan;

// -- TYPES

class CLOUD
{
    // -- ATTRIBUTES

    uint
        Version;
    string
        Name;
    char
        LeftAxisComponentLetter,
        UpAxisComponentLetter,
        ForwardAxisComponentLetter;
    PROPERTY[]
        PropertyArray;
    SCAN[]
        ScanArray;

    // -- CONSTRUCTORS

    this(
        )
    {
        LeftAxisComponentLetter = 'X';
        UpAxisComponentLetter = 'Y';
        ForwardAxisComponentLetter = 'Z';
    }

    // -- INQUIRIES

    ulong GetPointCount(
        )
    {
        ulong
            point_count;

        point_count = 0;

        foreach ( scan; ScanArray )
        {
            point_count += scan.PointCount;
        }

        return point_count;
    }

    // ~~

    void Write(
        STREAM stream
        )
    {
        stream.WriteNatural32( Version );
        stream.WriteText( Name );
        stream.WriteCharacter( LeftAxisComponentLetter );
        stream.WriteCharacter( UpAxisComponentLetter );
        stream.WriteCharacter( ForwardAxisComponentLetter );
        stream.WriteObjectArray( PropertyArray );
        stream.WriteObjectArray( ScanArray );
    }

    // ~~

    void WritePcfFile(
        string output_file_path
        )
    {
        STREAM
            stream;

        stream = new STREAM();
        stream.OpenOutputBinaryFile( output_file_path );
        stream.WriteObject( this );
        stream.CloseOutputBinaryFile();
    }

    // ~~

    void WritePtsFile(
        string output_file_path
        )
    {
        STREAM
            stream;

        stream = new STREAM();
        stream.OpenOutputTextFile( output_file_path );
        stream.WriteNaturalLine( GetPointCount() );

        foreach ( scan; ScanArray )
        {
            foreach ( cell; scan.CellMap.byValue )
            {
                foreach ( point_index; 0 .. cell.PointCount )
                {
                    stream.WriteRealLine(
                        cell.GetComponentValue( point_index, scan.ComponentArray, 0 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 1 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 2 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 3 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 4 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 5 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 6 )
                        );
                }
            }
        }

        stream.CloseOutputTextFile();
    }

    // ~~

    void WritePtxFile(
        string output_file_path
        )
    {
        STREAM
            stream;

        stream = new STREAM();
        stream.OpenOutputTextFile( output_file_path );

        foreach ( scan; ScanArray )
        {
            stream.WriteNaturalLine( scan.ColumnCount );
            stream.WriteNaturalLine( scan.RowCount );
            stream.WriteRealLine( scan.PositionVector.X, scan.PositionVector.Y, scan.PositionVector.Z );
            stream.WriteRealLine( scan.XAxisVector.X, scan.XAxisVector.Y, scan.XAxisVector.Z );
            stream.WriteRealLine( scan.YAxisVector.X, scan.YAxisVector.Y, scan.YAxisVector.Z );
            stream.WriteRealLine( scan.ZAxisVector.X, scan.ZAxisVector.Y, scan.ZAxisVector.Z );
            stream.WriteRealLine( scan.XAxisVector.X, scan.XAxisVector.Y, scan.XAxisVector.Z, 0.0 );
            stream.WriteRealLine( scan.YAxisVector.X, scan.YAxisVector.Y, scan.YAxisVector.Z, 0.0 );
            stream.WriteRealLine( scan.ZAxisVector.X, scan.ZAxisVector.Y, scan.ZAxisVector.Z, 0.0 );
            stream.WriteRealLine( scan.PositionVector.X, scan.PositionVector.Y, scan.PositionVector.Z, 1.0 );

            foreach ( cell; scan.CellMap.byValue )
            {
                foreach ( point_index; 0 .. cell.PointCount )
                {
                    stream.WriteRealLine(
                        cell.GetComponentValue( point_index, scan.ComponentArray, 0 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 1 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 2 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 3 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 4 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 5 ),
                        cell.GetComponentValue( point_index, scan.ComponentArray, 6 )
                        );
                }
            }
        }

        stream.CloseOutputTextFile();
    }

    // ~~

    void Dump(
        string indentation = ""
        )
    {
        writeln( indentation, "Version : ", Version );
        writeln( indentation, "Name : ", Name );
        writeln( indentation, "LeftAxisComponentLetter : ", LeftAxisComponentLetter );
        writeln( indentation, "UpAxisComponentLetter : ", UpAxisComponentLetter );
        writeln( indentation, "ForwardAxisComponentLetter : ", ForwardAxisComponentLetter );

        foreach ( property_index, property; PropertyArray )
        {
            writeln( indentation, "Property[", property_index, "] :" );

            property.Dump( indentation ~ "    " );
        }

        foreach ( scan_index, scan; ScanArray )
        {
            writeln( indentation, "Scan[", scan_index, "] :" );

            scan.Dump( indentation ~ "    " );
        }
    }

    // -- OPERATIONS

    void Clear(
        )
    {
        PropertyArray.destroy();
        ScanArray.destroy();
    }

    // ~~

    void SetAxisFormat(
        string axis_format
        )
    {
        assert( axis_format.length == 3 );

        LeftAxisComponentLetter = axis_format[ 0 ];
        UpAxisComponentLetter = axis_format[ 1 ];
        ForwardAxisComponentLetter = axis_format[ 2 ];
    }

    // ~~

    void Read(
        STREAM stream
        )
    {
        stream.ReadNatural32( Version );
        stream.ReadText( Name );
        stream.ReadCharacter( LeftAxisComponentLetter );
        stream.ReadCharacter( UpAxisComponentLetter );
        stream.ReadCharacter( ForwardAxisComponentLetter );
        stream.ReadObjectArray( PropertyArray );
        stream.ReadObjectArray( ScanArray );
    }

    // ~~

    void ReadPcfFile(
        string input_file_path
        )
    {
        STREAM
            stream;

        stream = new STREAM();
        stream.OpenInputBinaryFile( input_file_path );
        stream.ReadObjectValue( this );
        stream.CloseInputBinaryFile();
    }

    // ~~

    void ReadPtsFile(
        string input_file_path,
        COMPRESSION compression,
        ushort position_bit_count = 8,
        double position_precision = 0.001,
        double position_minimum = 0.0,
        double position_maximum = 0.0,
        ushort intensity_bit_count = 12,
        double intensity_precision = 1.0,
        double intensity_minimum = -2048.0,
        double intensity_maximum = 2047.0,
        ushort color_bit_count = 8,
        double color_precision = 1.0,
        double color_minimum = 0.0,
        double color_maximum = 255.0
        )
    {
        double
            color_blue,
            color_green,
            intensity,
            color_red,
            position_x,
            position_y,
            position_z;
        CELL
            cell;
        STREAM
            stream;
        SCAN
            scan;

        stream = new STREAM();
        stream.OpenInputTextFile( input_file_path );

        scan = new SCAN();

        if ( compression == COMPRESSION.None )
        {
            scan.ComponentArray ~= new COMPONENT( "X", COMPRESSION.None, 32, 0.0, 0.0, 0.0 );
            scan.ComponentArray ~= new COMPONENT( "Y", COMPRESSION.None, 32, 0.0, 0.0, 0.0 );
            scan.ComponentArray ~= new COMPONENT( "Z", COMPRESSION.None, 32, 0.0, 0.0, 0.0 );
            scan.ComponentArray ~= new COMPONENT( "I", COMPRESSION.None, 32, 0.0, 0.0, 0.0 );
            scan.ComponentArray ~= new COMPONENT( "R", COMPRESSION.None, 32, 0.0, 0.0, 0.0 );
            scan.ComponentArray ~= new COMPONENT( "G", COMPRESSION.None, 32, 0.0, 0.0, 0.0 );
            scan.ComponentArray ~= new COMPONENT( "B", COMPRESSION.None, 32, 0.0, 0.0, 0.0 );
        }
        else
        {
            assert( compression == COMPRESSION.Discretization );

            scan.ComponentArray ~= new COMPONENT( "X", COMPRESSION.Discretization, position_bit_count, position_precision, position_minimum, position_maximum );
            scan.ComponentArray ~= new COMPONENT( "Y", COMPRESSION.Discretization, position_bit_count, position_precision, position_minimum, position_maximum );
            scan.ComponentArray ~= new COMPONENT( "Z", COMPRESSION.Discretization, position_bit_count, position_precision, position_minimum, position_maximum );
            scan.ComponentArray ~= new COMPONENT( "I", COMPRESSION.Discretization, intensity_bit_count, intensity_precision, intensity_minimum, intensity_maximum );
            scan.ComponentArray ~= new COMPONENT( "R", COMPRESSION.Discretization, color_bit_count, color_precision, color_minimum, color_maximum );
            scan.ComponentArray ~= new COMPONENT( "G", COMPRESSION.Discretization, color_bit_count, color_precision, color_minimum, color_maximum );
            scan.ComponentArray ~= new COMPONENT( "B", COMPRESSION.Discretization, color_bit_count, color_precision, color_minimum, color_maximum );
        }

        if ( stream.ReadNaturalLine( scan.PointCount ) )
        {
            scan.ColumnCount = scan.PointCount;
            scan.RowCount = 1;

            foreach ( point_index; 0 .. scan.PointCount )
            {
                stream.ReadRealLine( position_x, position_y, position_z, intensity, color_red, color_green, color_blue );

                cell = scan.GetCell( position_x, position_y, position_z );
                cell.AddComponentValue( scan.ComponentArray, 0, position_x );
                cell.AddComponentValue( scan.ComponentArray, 1, position_y );
                cell.AddComponentValue( scan.ComponentArray, 2, position_z );
                cell.AddComponentValue( scan.ComponentArray, 3, intensity );
                cell.AddComponentValue( scan.ComponentArray, 4, color_red );
                cell.AddComponentValue( scan.ComponentArray, 5, color_green );
                cell.AddComponentValue( scan.ComponentArray, 6, color_blue );
                ++cell.PointCount;
            }

            ScanArray ~= scan;
        }

        stream.CloseInputTextFile();
    }

    // ~~

    void ReadPtxFile(
        string input_file_path,
        COMPRESSION compression,
        ushort position_bit_count = 8,
        double position_precision = 0.001,
        double position_minimum = 0.0,
        double position_maximum = 0.0,
        ushort intensity_bit_count = 8,
        double intensity_precision = 1.0 / 255.0,
        double intensity_minimum = 0.0,
        double intensity_maximum = 1.0,
        ushort color_bit_count = 8,
        double color_precision = 1.0,
        double color_minimum = 0.0,
        double color_maximum = 255.0
        )
    {
        double
            color_blue,
            color_green,
            intensity,
            color_red,
            position_w,
            position_x,
            position_y,
            position_z;
        CELL
            cell;
        STREAM
            stream;
        SCAN
            scan;

        stream = new STREAM();
        stream.OpenInputTextFile( input_file_path );

        for ( ; ; )
        {
            scan = new SCAN();

            if ( compression == COMPRESSION.None )
            {
                scan.ComponentArray ~= new COMPONENT( "X", COMPRESSION.None, 32, 0.0, 0.0, 0.0, 0.0 );
                scan.ComponentArray ~= new COMPONENT( "Y", COMPRESSION.None, 32, 0.0, 0.0, 0.0, 0.0 );
                scan.ComponentArray ~= new COMPONENT( "Z", COMPRESSION.None, 32, 0.0, 0.0, 0.0, 0.0 );
                scan.ComponentArray ~= new COMPONENT( "I", COMPRESSION.None, 32, 0.0, 0.0, 0.0, 0.0 );
                scan.ComponentArray ~= new COMPONENT( "R", COMPRESSION.None, 32, 0.0, 0.0, 0.0, 0.0 );
                scan.ComponentArray ~= new COMPONENT( "G", COMPRESSION.None, 32, 0.0, 0.0, 0.0, 0.0 );
                scan.ComponentArray ~= new COMPONENT( "B", COMPRESSION.None, 32, 0.0, 0.0, 0.0, 0.0 );
            }
            else
            {
                assert( compression == COMPRESSION.Discretization );

                scan.ComponentArray ~= new COMPONENT( "X", COMPRESSION.Discretization, position_bit_count, position_precision, position_minimum, position_minimum, position_maximum );
                scan.ComponentArray ~= new COMPONENT( "Y", COMPRESSION.Discretization, position_bit_count, position_precision, position_minimum, position_minimum, position_maximum );
                scan.ComponentArray ~= new COMPONENT( "Z", COMPRESSION.Discretization, position_bit_count, position_precision, position_minimum, position_minimum, position_maximum );
                scan.ComponentArray ~= new COMPONENT( "I", COMPRESSION.Discretization, intensity_bit_count, intensity_precision, intensity_minimum, intensity_minimum, intensity_maximum );
                scan.ComponentArray ~= new COMPONENT( "R", COMPRESSION.Discretization, color_bit_count, color_precision, color_minimum, color_minimum, color_maximum );
                scan.ComponentArray ~= new COMPONENT( "G", COMPRESSION.Discretization, color_bit_count, color_precision, color_minimum, color_minimum, color_maximum );
                scan.ComponentArray ~= new COMPONENT( "B", COMPRESSION.Discretization, color_bit_count, color_precision, color_minimum, color_minimum, color_maximum );
            }

            if ( stream.ReadNaturalLine( scan.ColumnCount ) )
            {
                stream.ReadNaturalLine( scan.RowCount );
                stream.ReadRealLine( scan.PositionVector.X, scan.PositionVector.Y, scan.PositionVector.Z );
                stream.ReadRealLine( scan.XAxisVector.X, scan.XAxisVector.Y, scan.XAxisVector.Z );
                stream.ReadRealLine( scan.YAxisVector.X, scan.YAxisVector.Y, scan.YAxisVector.Z );
                stream.ReadRealLine( scan.ZAxisVector.X, scan.ZAxisVector.Y, scan.ZAxisVector.Z );
                stream.ReadRealLine( position_x, position_y, position_z, position_w );
                stream.ReadRealLine( position_x, position_y, position_z, position_w );
                stream.ReadRealLine( position_x, position_y, position_z, position_w );
                stream.ReadRealLine( position_x, position_y, position_z, position_w );

                scan.PointCount = scan.ColumnCount * scan.RowCount;
                scan.SetRotationVector();

                foreach ( point_index; 0 .. scan.PointCount )
                {
                    stream.ReadRealLine( position_x, position_y, position_z, intensity, color_red, color_green, color_blue );

                    cell = scan.GetCell( position_x, position_y, position_z );
                    cell.AddComponentValue( scan.ComponentArray, 0, position_x );
                    cell.AddComponentValue( scan.ComponentArray, 1, position_y );
                    cell.AddComponentValue( scan.ComponentArray, 2, position_z );
                    cell.AddComponentValue( scan.ComponentArray, 3, intensity );
                    cell.AddComponentValue( scan.ComponentArray, 4, color_red );
                    cell.AddComponentValue( scan.ComponentArray, 5, color_green );
                    cell.AddComponentValue( scan.ComponentArray, 6, color_blue );
                    ++cell.PointCount;
                }

                ScanArray ~= scan;
            }
            else
            {
                break;
            }
        }

        stream.CloseInputTextFile();
    }
}
