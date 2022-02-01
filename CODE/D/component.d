module pcf.component;

// -- IMPORTS

import pcf.compression;
import pcf.stream;

// -- TYPES

class COMPONENT
{
    // -- ATTRIBUTES

    string
        Name;
    double
        Precision = 0.0;
    ushort
        BitCount,
        Compression;
    double
        MinimumValue = 0.0,
        OneOverPrecision = 0.0;

    // -- CONSTRUCTORS

    this(
        )
    {
    }

    // ~~

    this(
        string name,
        double precision = 1.0,
        ushort bit_count = 8,
        ushort compression = COMPRESSION.Discretization,
        double minimum_value = 0.0
        )
    {
        Name = name;
        Precision = precision;
        BitCount = bit_count;
        Compression = compression;
        MinimumValue = minimum_value;
        OneOverPrecision = 1.0 / precision;
    }

    // -- INQUIRIES

    void Write(
        STREAM stream
        )
    {
        stream.WriteText( Name );
        stream.WriteReal64( Precision );
        stream.WriteNatural16( BitCount );
        stream.WriteNatural16( Compression );
        stream.WriteReal64( MinimumValue );
        stream.WriteReal64( OneOverPrecision );
    }

    // -- OPERATIONS

    void Read(
        STREAM stream
        )
    {
        stream.ReadText( Name );
        stream.ReadReal64( Precision );
        stream.ReadNatural16( BitCount );
        stream.ReadNatural16( Compression );
        stream.ReadReal64( MinimumValue );
        stream.ReadReal64( OneOverPrecision );
    }
}
