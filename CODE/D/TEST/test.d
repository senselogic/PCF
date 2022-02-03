// -- IMPORTS

import pcf.base;
import pcf.cell;
import pcf.cloud;
import pcf.compression;
import std.conv : to;
import std.stdio: write, writeln;

// -- TYPES

class TEST
{
    // -- ATTRIBUTES

    CLOUD
        Cloud;

    // -- OPERATIONS

    void PrintCell(
        CELL cell
        )
    {
        writeln(
            "Cell : ",
            cell.PositionVector.X,
            " ",
            cell.PositionVector.Y,
            " ",
            cell.PositionVector.Z,
            " (",
            cell.PointCount,
            ")"
            );

        cell.SeekComponent( 0 );

        foreach ( point_index; 0 .. cell.PointCount )
        {
            write(
                "    [",
                point_index.to!string(),
                "]"
                );

            foreach ( buffer_index; 0 .. cell.BufferArray.length )
            {
                write(
                    " ",
                    cell.GetComponentValue( Cloud.ComponentArray, buffer_index ).GetText()
                    );
            }

            writeln( "" );
        }
    }

    // ~~

    void Run(
        )
    {
        CELL.PostWriteDelegate = &PrintCell;
        CELL.PostReadDelegate = &PrintCell;

        Cloud = new CLOUD();

        writeln( "Reading test.ptx" );
        Cloud.ReadPtxFile( "IN/test.ptx", COMPRESSION.None );

        writeln( "Writing test_1.pts" );
        Cloud.WritePtsFile( "OUT/test_1.pts" );

        writeln( "Writing test_1.ptx" );
        Cloud.WritePtxFile( "OUT/test_1.ptx" );

        writeln( "Writing test_1.pcf" );
        Cloud.WritePcfFile( "OUT/test_1.pcf" );

        Cloud = new CLOUD();

        writeln( "Reading test_1.pcf" );
        Cloud.ReadPcfFile( "OUT/test_1.pcf" );

        writeln( "Writing test_2.pts" );
        Cloud.WritePtsFile( "OUT/test_2.pts" );

        writeln( "Writing test_2.ptx" );
        Cloud.WritePtxFile( "OUT/test_2.ptx" );

        writeln( "Writing test_2.pcf" );
        Cloud.WritePcfFile( "OUT/test_2.pcf" );

        Cloud = new CLOUD();

        writeln( "Reading test.ptx" );
        Cloud.ReadPtxFile( "IN/test.ptx", COMPRESSION.Discretization, 8, 0.1 );

        writeln( "Writing test_3.pts" );
        Cloud.WritePtsFile( "OUT/test_3.pts" );

        writeln( "Writing test_3.ptx" );
        Cloud.WritePtxFile( "OUT/test_3.ptx" );

        writeln( "Writing test_3.pcf" );
        Cloud.WritePcfFile( "OUT/test_3.pcf" );

        Cloud = new CLOUD();

        writeln( "Reading test_3.pcf" );
        Cloud.ReadPcfFile( "OUT/test_3.pcf" );

        writeln( "Writing test_4.pts" );
        Cloud.WritePtsFile( "OUT/test_4.pts" );

        writeln( "Writing test_4.ptx" );
        Cloud.WritePtxFile( "OUT/test_4.ptx" );

        writeln( "Writing test_4.pcf" );
        Cloud.WritePcfFile( "OUT/test_4.pcf" );

        Cloud = new CLOUD();

        writeln( "Reading OUT/test_1.pts" );
        Cloud.ReadPtsFile( "OUT/test_1.pts", COMPRESSION.Discretization, 8, 0.1 );

        writeln( "Writing test_5.pts" );
        Cloud.WritePtsFile( "OUT/test_5.pts" );

        writeln( "Writing test_5.ptx" );
        Cloud.WritePtxFile( "OUT/test_5.ptx" );

        writeln( "Writing test_5.pcf" );
        Cloud.WritePcfFile( "OUT/test_3.pcf" );
    }
}

// -- FUNCTIONS

void main(
    string[] argument_array
    )
{
    TEST
        test;

    test = new TEST();
    test.Run();
}
