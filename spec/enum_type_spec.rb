require 'enum_type'

RSpec.describe EnumType do
  it 'is a module' do
    expect(EnumType).to be_instance_of Module
  end

  describe '.create' do
    context 'with no attributes' do
      let(:enum) do
        EnumType.create do
          RED(:red)
          GREEN(:green)
          BLUE(:blue)
        end
      end

      it 'defines all the enum types with the right value' do
        expect(enum.RED.value).to eq :red
        expect(enum.GREEN.value).to eq :green
        expect(enum.BLUE.value).to eq :blue
      end

      it 'defines all the enum types with the right name' do
        expect(enum.RED.name).to eq 'RED'
        expect(enum.GREEN.name).to eq 'GREEN'
        expect(enum.BLUE.name).to eq 'BLUE'
      end

      it 'defines all the enum types with simple equality rules' do
        expect(enum.RED).to eq enum.RED
        expect(enum.GREEN).to eq enum.GREEN
        expect(enum.BLUE).to eq enum.BLUE
      end

      it 'raises error on invalid enum name' do
        expect { enum.VIOLET }.to raise_error EnumType::UndefinedEnumError
      end

      it 'raises a NoMethodError if given arguments to a method' do
        expect { enum.RED('foo') }.to raise_error ArgumentError
      end

      it 'allows iterating over values' do
        expect(enum.map { |e| e }).to eq [enum.RED, enum.GREEN, enum.BLUE]
        expect(enum.map(&:value)).to eq %i[red green blue]
      end

      it 'allows looking up by name' do
        expect(enum[:RED]).to equal enum.RED
      end

      it 'allows looking up by string name' do
        expect(enum['RED']).to equal enum.RED
      end

      it 'allows looking up by value' do
        expect(enum[:red]).to equal enum.RED
      end
    end

    context 'with array attributes' do
      let(:enum) do
        EnumType.create(:hex, :rgb) do
          RED(:red, '#f00', [255, 0, 0])
          GREEN(:green, '#0f0', [0, 255, 0])
          BLUE(:blue, '#00f', [0, 0, 255])
        end
      end

      it 'defines all the enum types with the right value' do
        expect(enum.RED.value).to eq :red
        expect(enum.GREEN.value).to eq :green
        expect(enum.BLUE.value).to eq :blue
      end

      it 'defines all the enum types with the right name' do
        expect(enum.RED.name).to eq 'RED'
        expect(enum.GREEN.name).to eq 'GREEN'
        expect(enum.BLUE.name).to eq 'BLUE'
      end

      it 'defines other attributes correctly' do
        expect(enum.RED.hex).to eq '#f00'
        expect(enum.GREEN.hex).to eq '#0f0'
        expect(enum.BLUE.hex).to eq '#00f'
        expect(enum.RED.rgb).to eq [255, 0, 0]
        expect(enum.GREEN.rgb).to eq [0, 255, 0]
        expect(enum.BLUE.rgb).to eq [0, 0, 255]
      end

      it 'raises a NoMethodError if given arguments to a method' do
        expect { enum.RED('foo') }.to raise_error ArgumentError
      end

      it 'allows iterating over values' do
        expect(enum.map { |e| e }).to eq [enum.RED, enum.GREEN, enum.BLUE]
        expect(enum.map(&:value)).to eq %i[red green blue]
        expect(enum.map(&:hex)).to eq %w[#f00 #0f0 #00f]
        expect(enum.map(&:rgb)).to eq [[255, 0, 0], [0, 255, 0], [0, 0, 255]]
      end
    end

    context 'with hash attributes' do
      let(:enum) do
        EnumType.create(value: Symbol, hex: String, rgb: Array) do
          RED(:red, '#f00', [255, 0, 0])
          GREEN(:green, '#0f0', [0, 255, 0])
          BLUE(:blue, '#00f', [0, 0, 255])
        end
      end

      it 'defines all the enum types with the right value' do
        expect(enum.RED.value).to eq :red
        expect(enum.GREEN.value).to eq :green
        expect(enum.BLUE.value).to eq :blue
      end

      it 'defines all the enum types with the right name' do
        expect(enum.RED.name).to eq 'RED'
        expect(enum.GREEN.name).to eq 'GREEN'
        expect(enum.BLUE.name).to eq 'BLUE'
      end

      it 'defines other attributes correctly' do
        expect(enum.RED.hex).to eq '#f00'
        expect(enum.GREEN.hex).to eq '#0f0'
        expect(enum.BLUE.hex).to eq '#00f'
        expect(enum.RED.rgb).to eq [255, 0, 0]
        expect(enum.GREEN.rgb).to eq [0, 255, 0]
        expect(enum.BLUE.rgb).to eq [0, 0, 255]
      end

      it 'raises a NoMethodError if given arguments to a method' do
        expect { enum.RED('foo') }.to raise_error ArgumentError
      end

      it 'allows iterating over values' do
        expect(enum.map { |e| e }).to eq [enum.RED, enum.GREEN, enum.BLUE]
        expect(enum.map(&:value)).to eq %i[red green blue]
        expect(enum.map(&:hex)).to eq %w[#f00 #0f0 #00f]
        expect(enum.map(&:rgb)).to eq [[255, 0, 0], [0, 255, 0], [0, 0, 255]]
      end
    end

    context 'with hash attributes and an invalid definition' do
      let(:enum) do
        EnumType.create(value: Symbol, hex: String, rgb: Array) do
          RED(:red, '#f00', [255, 0, 0])
          GREEN(:green, 27, [0, 255, 0])
        end
      end

      it 'raises a type error' do
        expect { enum }.to raise_error EnumType::TypeError
      end
    end

    context 'an enum with a lower case type' do
      let(:enum) do
        EnumType.create do
          red(:red)
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'an enum with an empty type' do
      let(:enum) do
        EnumType.create do
          RED()
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with duplicated definitions' do
      let(:enum) do
        EnumType.create do
          RED(:red)
          GREEN(:green)
          RED(:blue)
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::DuplicateDefinitionError
      end
    end

    context 'with duplicated values' do
      let(:enum) do
        EnumType.create do
          RED(:red)
          GREEN(:green)
          BLUE(:red)
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::DuplicateDefinitionError
      end
    end

    context 'with an empty block' do
      let(:enum) { EnumType.create {} }

      it 'raises an InvalidDefinitionError' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with no block' do
      let(:enum) { EnumType.create }

      it 'raises an InvalidDefinitionError' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with an enum definition with a block' do
      let(:enum) do
        EnumType.create do
          RED(:red) { 'foo' }
        end
      end

      it 'raises an InvalidDefinitionError' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end
  end
end
