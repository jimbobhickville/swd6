from sqlalchemy import BigInteger, Column, Enum, Float, ForeignKey, Index, Integer, SmallInteger, String, Table, Text, text
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql.base import ARRAY
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class Ability(Base):
    __tablename__ = 'ability'

    ability_id = Column(Integer, primary_key=True, server_default=text("nextval('ability_ability_id_seq'::regclass)"))
    skill_id = Column(SmallInteger, nullable=False)
    name = Column(String(100), nullable=False)
    difficulty = Column(Text, nullable=False)
    time_required = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)

    prereq_abilitys = relationship(
        'Ability',
        secondary='ability_prerequisite',
        primaryjoin='Ability.ability_id == ability_prerequisite.c.ability_id',
        secondaryjoin='Ability.ability_id == ability_prerequisite.c.prereq_ability_id'
    )


t_ability_prerequisite = Table(
    'ability_prerequisite', metadata,
    Column('ability_id', ForeignKey('ability.ability_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('prereq_ability_id', ForeignKey('ability.ability_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class Armor(Base):
    __tablename__ = 'armor'

    armor_id = Column(Integer, primary_key=True, server_default=text("nextval('armor_armor_id_seq'::regclass)"))
    areas_covered = Column(ARRAY(ENUM('Head', 'Neck', 'Upper Chest', 'Abdomen', 'Groin', 'Upper Back', 'Lower Back', 'Buttocks', 'Shoulders', 'Upper Arms', 'Forearms', 'Hands', 'Thighs', 'Shins', 'Feet', 'Joints', name='armor_areas_covered')), nullable=False)
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    resist_physical_dice = Column(SmallInteger, nullable=False)
    resist_physical_pip = Column(SmallInteger, nullable=False)
    resist_energy_dice = Column(SmallInteger, nullable=False)
    resist_energy_pip = Column(SmallInteger, nullable=False)
    availability = Column(Enum('Common', 'Rare', 'Not For Sale', name='armor_availability'), nullable=False, server_default=text("'Common'::armor_availability"))
    price_new = Column(SmallInteger, nullable=False)
    price_used = Column(SmallInteger, nullable=False)

    characters = relationship('CharacterSheet', secondary='character_armor')


class Attribute(Base):
    __tablename__ = 'attribute'

    attrib_id = Column(Integer, primary_key=True, server_default=text("nextval('attribute_attrib_id_seq'::regclass)"))
    name = Column(String(30), nullable=False)
    abbreviation = Column(String(3), nullable=False)
    description = Column(Text, nullable=False)
    has_level = Column(SmallInteger, nullable=False, index=True, server_default=text("'1'::smallint"))


t_character_armor = Table(
    'character_armor', metadata,
    Column('character_id', ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('armor_id', ForeignKey('armor.armor_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class CharacterSheet(Base):
    __tablename__ = 'character_sheet'

    character_id = Column(BigInteger, primary_key=True, server_default=text("nextval('character_sheet_character_id_seq'::regclass)"))
    race_id = Column(ForeignKey('race.race_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    planet_id = Column(ForeignKey('planet.planet_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    character_type_id = Column(ForeignKey('character_type.character_type_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    is_template = Column(SmallInteger, nullable=False, index=True, server_default=text("'0'::smallint"))
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    background = Column(Text, nullable=False)
    motivation = Column(Text, nullable=False)
    quote = Column(Text, nullable=False)
    gender = Column(Enum('M', 'F', name='character_sheet_gender'), nullable=False, server_default=text("'M'::character_sheet_gender"))
    age = Column(SmallInteger, nullable=False)
    height = Column(Float(53), nullable=False)
    weight = Column(SmallInteger, nullable=False)
    move_land = Column(SmallInteger, nullable=False, server_default=text("'10'::smallint"))
    move_water = Column(SmallInteger, nullable=False, server_default=text("'0'::smallint"))
    move_air = Column(SmallInteger, nullable=False, server_default=text("'0'::smallint"))
    force_pts = Column(SmallInteger, nullable=False)
    dark_side_pts = Column(SmallInteger, nullable=False)
    character_pts = Column(SmallInteger, nullable=False)
    credits_owned = Column(BigInteger, nullable=False)
    credits_debt = Column(BigInteger, nullable=False)

    character_type = relationship('CharacterType')
    planet = relationship('Planet')
    race = relationship('Race')
    rangeds = relationship('WeaponRanged', secondary='character_weapon_ranged')
    starships = relationship('Starship', secondary='character_starship')
    melees = relationship('WeaponMelee', secondary='character_weapon_melee')
    explosives = relationship('WeaponExplosive', secondary='character_weapon_explosive')
    vehicles = relationship('Vehicle', secondary='character_vehicle')


t_character_skill_level = Table(
    'character_skill_level', metadata,
    Column('character_id', ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('attrib_id', ForeignKey('attribute.attrib_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('skill_id', ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True),
    Column('specialize_id', ForeignKey('skill_specialization.specialize_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True),
    Column('skill_dice', SmallInteger, nullable=False),
    Column('skill_pip', SmallInteger, nullable=False)
)


t_character_starship = Table(
    'character_starship', metadata,
    Column('character_id', ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('starship_id', ForeignKey('starship.starship_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class CharacterType(Base):
    __tablename__ = 'character_type'

    character_type_id = Column(Integer, primary_key=True, server_default=text("nextval('character_type_character_type_id_seq'::regclass)"))
    name = Column(String(50), nullable=False)


t_character_vehicle = Table(
    'character_vehicle', metadata,
    Column('character_id', ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('vehicle_id', ForeignKey('vehicle.vehicle_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_explosive = Table(
    'character_weapon_explosive', metadata,
    Column('character_id', ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('explosive_id', ForeignKey('weapon_explosive.explosive_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_melee = Table(
    'character_weapon_melee', metadata,
    Column('character_id', ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('melee_id', ForeignKey('weapon_melee.melee_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_ranged = Table(
    'character_weapon_ranged', metadata,
    Column('character_id', ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('ranged_id', ForeignKey('weapon_ranged.ranged_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class Image(Base):
    __tablename__ = 'image'

    image_id = Column(BigInteger, primary_key=True, server_default=text("nextval('image_image_id_seq'::regclass)"))
    mod_name = Column(String(40), nullable=False, index=True)
    id = Column(BigInteger, nullable=False, index=True)
    order_num = Column(SmallInteger, nullable=False)
    name = Column(String(120), nullable=False)
    dir = Column(String(100), nullable=False)
    caption = Column(String(200), nullable=False)
    image_width = Column(SmallInteger, nullable=False)
    image_height = Column(SmallInteger, nullable=False)
    thumb_width = Column(SmallInteger, nullable=False)
    thumb_height = Column(SmallInteger, nullable=False)


class Modifier(Base):
    __tablename__ = 'modifier'

    modifier_id = Column(BigInteger, primary_key=True, server_default=text("nextval('modifier_modifier_id_seq'::regclass)"))
    mod_name = Column(String(40), nullable=False, index=True)
    id = Column(BigInteger, nullable=False, index=True)
    attrib_id = Column(ForeignKey('attribute.attrib_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    specialize_id = Column(ForeignKey('skill_specialization.specialize_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    modifier_dice = Column(SmallInteger, nullable=False)
    modifier_pip = Column(SmallInteger, nullable=False)
    conditions = Column(Text, nullable=False)

    attrib = relationship('Attribute')
    skill = relationship('Skill')
    specialize = relationship('SkillSpecialization')


class Planet(Base):
    __tablename__ = 'planet'

    planet_id = Column(Integer, primary_key=True, server_default=text("nextval('planet_planet_id_seq'::regclass)"))
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)


class Race(Base):
    __tablename__ = 'race'

    race_id = Column(Integer, primary_key=True, server_default=text("nextval('race_race_id_seq'::regclass)"))
    planet_id = Column(ForeignKey('planet.planet_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    playable_type = Column(Enum('PC', 'NPC', 'Creature', name='race_playable_type'), nullable=False, index=True, server_default=text("'PC'::race_playable_type"))
    name = Column(String(100), nullable=False)
    basic_ability = Column(Enum('Speak', 'Understand', 'None', name='race_basic_ability'), nullable=False, server_default=text("'Speak'::race_basic_ability"))
    description = Column(Text, nullable=False)
    special_abilities = Column(Text, nullable=False)
    story_factors = Column(Text, nullable=False)
    attribute_dice = Column(SmallInteger, nullable=False, server_default=text("'12'::smallint"))
    attribute_pip = Column(SmallInteger, nullable=False)
    min_move_land = Column(SmallInteger, nullable=False, server_default=text("'10'::smallint"))
    max_move_land = Column(SmallInteger, nullable=False, server_default=text("'12'::smallint"))
    min_move_water = Column(SmallInteger, nullable=False, server_default=text("'5'::smallint"))
    max_move_water = Column(SmallInteger, nullable=False, server_default=text("'6'::smallint"))
    min_move_air = Column(SmallInteger, nullable=False, server_default=text("'0'::smallint"))
    max_move_air = Column(SmallInteger, nullable=False, server_default=text("'0'::smallint"))
    min_height = Column(Float(53), nullable=False, server_default=text("'1.5'::double precision"))
    max_height = Column(Float(53), nullable=False, server_default=text("'2'::double precision"))

    planet = relationship('Planet')


t_race_attrib_levels = Table(
    'race_attrib_levels', metadata,
    Column('race_id', ForeignKey('race.race_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('attrib_id', ForeignKey('attribute.attrib_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('min_dice', SmallInteger, nullable=False, server_default=text("'2'::smallint")),
    Column('min_pip', SmallInteger, nullable=False),
    Column('max_dice', SmallInteger, nullable=False, server_default=text("'4'::smallint")),
    Column('max_pip', SmallInteger, nullable=False),
    Index('idx_16565_race_id_2', 'race_id', 'attrib_id', unique=True)
)


class Scale(Base):
    __tablename__ = 'scale'

    scale_id = Column(Integer, primary_key=True, server_default=text("nextval('scale_scale_id_seq'::regclass)"))
    name = Column(String(30), nullable=False)
    scale_dice = Column(SmallInteger, nullable=False)
    scale_pip = Column(SmallInteger, nullable=False)


class Skill(Base):
    __tablename__ = 'skill'

    skill_id = Column(Integer, primary_key=True, server_default=text("nextval('skill_skill_id_seq'::regclass)"))
    attrib_id = Column(ForeignKey('attribute.attrib_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    has_specializations = Column(SmallInteger, nullable=False, server_default=text("'1'::smallint"))
    has_abilities = Column(SmallInteger, nullable=False, server_default=text("'0'::smallint"))

    attrib = relationship('Attribute')


t_skill_advanced = Table(
    'skill_advanced', metadata,
    Column('skill_id', ForeignKey('skill.skill_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('base_skill_id', ForeignKey('skill.skill_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('prereq_dice', SmallInteger, nullable=False),
    Column('prereq_pip', SmallInteger, nullable=False)
)


class SkillSpecialization(Base):
    __tablename__ = 'skill_specialization'

    specialize_id = Column(Integer, primary_key=True, server_default=text("nextval('skill_specialization_specialize_id_seq'::regclass)"))
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    name = Column(String(100), nullable=False)

    skill = relationship('Skill')


class Starship(Base):
    __tablename__ = 'starship'

    starship_id = Column(Integer, primary_key=True, server_default=text("nextval('starship_starship_id_seq'::regclass)"))
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    scale_id = Column(ForeignKey('scale.scale_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = Column(String(100), nullable=False)
    type = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    length = Column(Float(53), nullable=False)
    capacity_crew = Column(SmallInteger, nullable=False)
    capacity_passengers = Column(SmallInteger, nullable=False)
    capacity_troops = Column(SmallInteger, nullable=False)
    capacity_cargo = Column(SmallInteger, nullable=False)
    capacity_consumables = Column(SmallInteger, nullable=False)
    has_nav_computer = Column(SmallInteger, nullable=False)
    hyperdrive_multiplier = Column(Float(53), nullable=False)
    hyperdrive_backup = Column(Float(53), nullable=False)
    speed_space = Column(SmallInteger, nullable=False)
    speed_atmosphere_min = Column(SmallInteger, nullable=False)
    speed_atmosphere_max = Column(SmallInteger, nullable=False)
    maneuver_dice = Column(SmallInteger, nullable=False)
    maneuver_pip = Column(SmallInteger, nullable=False)
    hull_dice = Column(SmallInteger, nullable=False)
    hull_pip = Column(SmallInteger, nullable=False)
    shields_dice = Column(SmallInteger, nullable=False)
    shields_pip = Column(SmallInteger, nullable=False)
    sensors_passive_range = Column(SmallInteger, nullable=False)
    sensors_passive_dice = Column(SmallInteger, nullable=False)
    sensors_passive_pip = Column(SmallInteger, nullable=False)
    sensors_scan_range = Column(SmallInteger, nullable=False)
    sensors_scan_dice = Column(SmallInteger, nullable=False)
    sensors_scan_pip = Column(SmallInteger, nullable=False)
    sensors_search_range = Column(SmallInteger, nullable=False)
    sensors_search_dice = Column(SmallInteger, nullable=False)
    sensors_search_pip = Column(SmallInteger, nullable=False)
    sensors_focus_range = Column(SmallInteger, nullable=False)
    sensors_focus_dice = Column(SmallInteger, nullable=False)
    sensors_focus_pip = Column(SmallInteger, nullable=False)
    availability = Column(Enum('Common', 'Rare', 'Not For Sale', name='starship_availability'), nullable=False, server_default=text("'Common'::starship_availability"))
    price_new = Column(Integer)
    price_used = Column(Integer)

    scale = relationship('Scale')
    skill = relationship('Skill')


class StarshipWeapon(Base):
    __tablename__ = 'starship_weapon'

    starship_weapon_id = Column(BigInteger, primary_key=True, server_default=text("nextval('starship_weapon_starship_weapon_id_seq'::regclass)"))
    starship_id = Column(ForeignKey('starship.starship_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    type = Column(String(100), nullable=False)
    number = Column(SmallInteger, nullable=False)
    crew = Column(SmallInteger, nullable=False)
    fire_rate = Column(Float(53))
    fire_control_dice = Column(SmallInteger, nullable=False)
    fire_control_pip = Column(SmallInteger, nullable=False)
    fire_arc = Column(ARRAY(ENUM('Above', 'Below', 'Front', 'Back', 'Left', 'Right', name='starship_weapon_fire_arc')), nullable=False)
    fire_linked = Column(SmallInteger, nullable=False)
    range_minimum_space = Column(SmallInteger, nullable=False)
    range_short_space = Column(SmallInteger, nullable=False)
    range_medium_space = Column(SmallInteger, nullable=False)
    range_long_space = Column(SmallInteger, nullable=False)
    range_minimum_atmosphere = Column(SmallInteger, nullable=False)
    range_short_atmosphere = Column(SmallInteger, nullable=False)
    range_medium_atmosphere = Column(SmallInteger, nullable=False)
    range_long_atmosphere = Column(SmallInteger, nullable=False)
    damage_dice = Column(SmallInteger, nullable=False)
    damage_pip = Column(SmallInteger, nullable=False)

    skill = relationship('Skill')
    starship = relationship('Starship')


class Vehicle(Base):
    __tablename__ = 'vehicle'

    vehicle_id = Column(Integer, primary_key=True, server_default=text("nextval('vehicle_vehicle_id_seq'::regclass)"))
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    scale_id = Column(ForeignKey('scale.scale_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = Column(String(100), nullable=False)
    type = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    cover = Column(Float(53), nullable=False)
    capacity_crew = Column(SmallInteger, nullable=False)
    capacity_passengers = Column(SmallInteger, nullable=False)
    capacity_troops = Column(SmallInteger, nullable=False)
    capacity_cargo = Column(SmallInteger, nullable=False)
    capacity_consumables = Column(SmallInteger, nullable=False)
    speed_min = Column(SmallInteger, nullable=False)
    speed_max = Column(SmallInteger, nullable=False)
    altitude_min = Column(SmallInteger, nullable=False)
    altitude_max = Column(SmallInteger, nullable=False)
    maneuver_dice = Column(SmallInteger, nullable=False)
    maneuver_pip = Column(SmallInteger, nullable=False)
    hull_dice = Column(SmallInteger, nullable=False)
    hull_pip = Column(SmallInteger, nullable=False)
    shields_dice = Column(SmallInteger, nullable=False)
    shields_pip = Column(SmallInteger, nullable=False)
    availability = Column(Enum('Common', 'Rare', 'Not For Sale', name='vehicle_availability'), nullable=False, server_default=text("'Common'::vehicle_availability"))
    price_new = Column(Integer)
    price_used = Column(Integer)

    scale = relationship('Scale')
    skill = relationship('Skill')


class VehicleWeapon(Base):
    __tablename__ = 'vehicle_weapon'

    vehicle_weapon_id = Column(BigInteger, primary_key=True, server_default=text("nextval('vehicle_weapon_vehicle_weapon_id_seq'::regclass)"))
    vehicle_id = Column(ForeignKey('vehicle.vehicle_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    type = Column(String(100), nullable=False)
    number = Column(SmallInteger, nullable=False)
    crew = Column(SmallInteger, nullable=False)
    fire_rate = Column(Float(53))
    fire_control_dice = Column(SmallInteger, nullable=False)
    fire_control_pip = Column(SmallInteger, nullable=False)
    fire_arc = Column(ARRAY(ENUM('Above', 'Below', 'Front', 'Back', 'Left', 'Right', name='vehicle_weapon_fire_arc')), nullable=False)
    fire_linked = Column(SmallInteger, nullable=False)
    range_minimum = Column(SmallInteger, nullable=False)
    range_short = Column(SmallInteger, nullable=False)
    range_medium = Column(SmallInteger, nullable=False)
    range_long = Column(SmallInteger, nullable=False)
    damage_dice = Column(SmallInteger, nullable=False)
    damage_pip = Column(SmallInteger, nullable=False)

    skill = relationship('Skill')
    vehicle = relationship('Vehicle')


class WeaponExplosive(Base):
    __tablename__ = 'weapon_explosive'

    explosive_id = Column(Integer, primary_key=True, server_default=text("nextval('weapon_explosive_explosive_id_seq'::regclass)"))
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    range_minimum = Column(SmallInteger, nullable=False)
    range_short = Column(SmallInteger, nullable=False)
    range_medium = Column(SmallInteger, nullable=False)
    range_long = Column(SmallInteger, nullable=False)

    skill = relationship('Skill')


t_weapon_explosive_damage = Table(
    'weapon_explosive_damage', metadata,
    Column('explosive_id', ForeignKey('weapon_explosive.explosive_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    Column('radius', SmallInteger, nullable=False),
    Column('damage_dice', SmallInteger, nullable=False),
    Column('damage_pip', SmallInteger, nullable=False)
)


class WeaponMelee(Base):
    __tablename__ = 'weapon_melee'

    melee_id = Column(Integer, primary_key=True, server_default=text("nextval('weapon_melee_melee_id_seq'::regclass)"))
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    damage_dice = Column(SmallInteger, nullable=False)
    damage_pip = Column(SmallInteger, nullable=False)
    max_damage_dice = Column(SmallInteger, nullable=False)
    max_damage_pip = Column(SmallInteger, nullable=False)

    skill = relationship('Skill')


class WeaponRanged(Base):
    __tablename__ = 'weapon_ranged'

    ranged_id = Column(Integer, primary_key=True, server_default=text("nextval('weapon_ranged_ranged_id_seq'::regclass)"))
    skill_id = Column(ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=False)
    fire_rate = Column(Float(53))
    range_minimum = Column(SmallInteger, nullable=False)
    range_short = Column(SmallInteger, nullable=False)
    range_medium = Column(SmallInteger, nullable=False)
    range_long = Column(SmallInteger, nullable=False)
    damage_dice = Column(SmallInteger, nullable=False)
    damage_pip = Column(SmallInteger, nullable=False)

    skill = relationship('Skill')