import flask_sqlalchemy
from sqlalchemy.dialects import postgresql as pg

db = flask_sqlalchemy.SQLAlchemy()


class Armor(db.Model):
    __tablename__ = 'armor'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    areas_covered = db.Column(pg.ARRAY(pg.ENUM('Head', 'Neck', 'Upper Chest', 'Abdomen', 'Groin', 'Upper Back', 'Lower Back', 'Buttocks', 'Shoulders', 'Upper Arms', 'Forearms', 'Hands', 'Thighs', 'Shins', 'Feet', 'Joints', name='armor_areas_covered')), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    resist_physical_dice = db.Column(db.SmallInteger, nullable=False)
    resist_physical_pip = db.Column(db.SmallInteger, nullable=False)
    resist_energy_dice = db.Column(db.SmallInteger, nullable=False)
    resist_energy_pip = db.Column(db.SmallInteger, nullable=False)
    availability = db.Column(db.Enum('Common', 'Rare', 'Not For Sale', name='armor_availability'), nullable=False, server_default=db.text("'Common'::armor_availability"))
    price_new = db.Column(db.SmallInteger, nullable=False)
    price_used = db.Column(db.SmallInteger, nullable=False)

    characters = db.relationship('CharacterSheet', secondary='character_armor')
    images = db.relationship('Image', secondary='armor_image')


t_armor_image = db.Table(
    'armor_image', db.metadata,
    db.Column('armor_id', db.ForeignKey('armor.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False),
    db.UniqueConstraint('armor_id', 'image_id')
)


class Attribute(db.Model):
    __tablename__ = 'attribute'

    name = db.Column(db.String(30), nullable=False)
    id = db.Column(db.String(3), primary_key=True)
    description = db.Column(db.Text, nullable=False)


t_character_armor = db.Table(
    'character_armor', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('armor_id', db.ForeignKey('armor.id', ondelete='CASCADE', onupdate='RESTRICT'),
              nullable=False, index=True)
)


class CharacterAttribute(db.Model):
    __tablename__ = 'character_attribute'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    character_id = db.Column(db.ForeignKey('character_sheet.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)
    attribute_id = db.Column(db.ForeignKey('attribute.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)
    level = db.Column(db.Numeric(3, 1), nullable=False)

    attribute = db.relationship('Attribute')
    character = db.relationship('CharacterSheet')


class CharacterSheet(db.Model):
    __tablename__ = 'character_sheet'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    race_id = db.Column(db.ForeignKey('race.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False, index=True)
    planet_id = db.Column(db.ForeignKey('planet.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    character_type_id = db.Column(db.ForeignKey('character_type.character_type_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    background = db.Column(db.Text, nullable=False)
    motivation = db.Column(db.Text, nullable=False)
    quote = db.Column(db.Text, nullable=False)
    gender = db.Column(db.Enum('M', 'F', name='character_sheet_gender'), nullable=False, server_default=db.text("'M'::character_sheet_gender"))
    age = db.Column(db.SmallInteger, nullable=False)
    height = db.Column(db.Numeric(3, 1), nullable=False)
    weight = db.Column(db.Integer, nullable=False)
    move_land = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'10'::smallint"))
    move_water = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    move_air = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    force_pts = db.Column(db.SmallInteger, nullable=False)
    dark_side_pts = db.Column(db.SmallInteger, nullable=False)
    character_pts = db.Column(db.SmallInteger, nullable=False)
    credits_bank = db.Column(db.BigInteger, nullable=False)
    credits_debt = db.Column(db.BigInteger, nullable=False)
    is_template = db.Column(db.Boolean, nullable=False, server_default=db.text("false"))

    character_type = db.relationship('CharacterType')
    planet = db.relationship('Planet')
    race = db.relationship('Race')
    explosives = db.relationship('WeaponExplosive', secondary='character_weapon_explosive')
    vehicles = db.relationship('Vehicle', secondary='character_vehicle')
    melee_weapons = db.relationship('WeaponMelee', secondary='character_weapon_melee')
    starships = db.relationship('Starship', secondary='character_starship')
    ranged_weapons = db.relationship('WeaponRanged', secondary='character_weapon_ranged')


class CharacterSkill(db.Model):
    __tablename__ = 'character_skill'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    character_id = db.Column(db.ForeignKey('character_sheet.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)
    level = db.Column(db.Numeric(3, 1), nullable=False)

    character = db.relationship('CharacterSheet')
    skill = db.relationship('Skill')


class CharacterSpecialization(db.Model):
    __tablename__ = 'character_specialization'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    character_id = db.Column(db.ForeignKey('character_sheet.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)
    specialization_id = db.Column(db.ForeignKey('skill_specialization.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)
    level = db.Column(db.Numeric(3, 1), nullable=False)

    character = db.relationship('CharacterSheet')
    specialization = db.relationship('SkillSpecialization')


t_character_starship = db.Table(
    'character_starship', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('starship_id', db.ForeignKey('starship.starship_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class CharacterType(db.Model):
    __tablename__ = 'character_type'

    character_type_id = db.Column(db.Integer, primary_key=True, server_default=db.text("nextval('character_type_character_type_id_seq'::regclass)"))
    name = db.Column(db.String(50), nullable=False)


t_character_vehicle = db.Table(
    'character_vehicle', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('vehicle_id', db.ForeignKey('vehicle.vehicle_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_explosive = db.Table(
    'character_weapon_explosive', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('explosive_id', db.ForeignKey('weapon_explosive.explosive_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_melee = db.Table(
    'character_weapon_melee', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('melee_id', db.ForeignKey('weapon_melee.melee_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_ranged = db.Table(
    'character_weapon_ranged', db.metadata,
    db.Column('character_id', db.ForeignKey('character_sheet.id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('ranged_id', db.ForeignKey('weapon_ranged.ranged_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class ForceAbility(db.Model):
    __tablename__ = 'force_ability'

    name = db.Column(db.String(100), nullable=False)
    difficulty = db.Column(db.Text, nullable=False)
    time_required = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    force_power_id = db.Column(pg.UUID)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))


class ForceAbilityPrerequisite(db.Model):
    __tablename__ = 'force_ability_prerequisite'
    __table_args__ = (
        db.UniqueConstraint('force_ability_id', 'prerequisite_id'),
    )

    force_ability_id = db.Column(pg.UUID)
    prerequisite_id = db.Column(pg.UUID)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))


class ForcePower(db.Model):
    __tablename__ = 'force_power'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)


class Image(db.Model):
    __tablename__ = 'image'

    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    order_num = db.Column(db.SmallInteger, nullable=False)
    name = db.Column(db.String(120), nullable=False)
    dir = db.Column(db.String(100), nullable=False)
    caption = db.Column(db.String(200), nullable=False)
    image_width = db.Column(db.SmallInteger, nullable=False)
    image_height = db.Column(db.SmallInteger, nullable=False)
    thumb_width = db.Column(db.SmallInteger, nullable=False)
    thumb_height = db.Column(db.SmallInteger, nullable=False)


class Planet(db.Model):
    __tablename__ = 'planet'

    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))

    images = db.relationship('Image', secondary='planet_image')


t_planet_image = db.Table(
    'planet_image', db.metadata,
    db.Column('planet_id', db.ForeignKey('planet.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False),
    db.UniqueConstraint('planet_id', 'image_id')
)


class Race(db.Model):
    __tablename__ = 'race'

    playable_type = db.Column(db.Enum('PC', 'NPC', 'Creature', name='race_playable_type'), nullable=False, index=True, server_default=db.text("'PC'::race_playable_type"))
    name = db.Column(db.String(100), nullable=False)
    basic_ability = db.Column(db.Enum('Speak', 'Understand', 'None', name='race_basic_ability'), nullable=False, server_default=db.text("'Speak'::race_basic_ability"))
    description = db.Column(db.Text, nullable=False)
    special_abilities = db.Column(db.Text, nullable=False)
    story_factors = db.Column(db.Text, nullable=False)
    min_move_land = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'10'::smallint"))
    max_move_land = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'12'::smallint"))
    min_move_water = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'5'::smallint"))
    max_move_water = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'6'::smallint"))
    min_move_air = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    max_move_air = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    min_height = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("'1.5'::double precision"))
    max_height = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("'2'::double precision"))
    attribute_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("12.0"))
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    planet_id = db.Column(db.ForeignKey('planet.id', ondelete='RESTRICT', onupdate='CASCADE'))

    planet = db.relationship('Planet')
    images = db.relationship('Image', secondary='race_image')


t_race_image = db.Table(
    'race_image', db.metadata,
    db.Column('race_id', db.ForeignKey('race.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False),
    db.Column('image_id', db.ForeignKey('image.id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False),
    db.UniqueConstraint('race_id', 'image_id')
)


class RaceAttribute(db.Model):
    __tablename__ = 'race_attribute'
    __table_args__ = (
        db.UniqueConstraint('race_id', 'attribute_id'),
    )

    min_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("2.0"))
    max_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("4.0"))
    race_id = db.Column(db.ForeignKey('race.id', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    attribute_id = db.Column(db.ForeignKey('attribute.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))

    attribute = db.relationship('Attribute')
    race = db.relationship('Race', backref='race_attributes')


class Scale(db.Model):
    __tablename__ = 'scale'

    scale_id = db.Column(db.Integer, primary_key=True, server_default=db.text("nextval('scale_scale_id_seq'::regclass)"))
    name = db.Column(db.String(30), nullable=False)
    scale_dice = db.Column(db.SmallInteger, nullable=False)
    scale_pip = db.Column(db.SmallInteger, nullable=False)


class Skill(db.Model):
    __tablename__ = 'skill'

    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    has_specializations = db.Column(db.Boolean, nullable=False, server_default=db.text("true"))
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    attribute_id = db.Column(db.ForeignKey('attribute.id', ondelete='RESTRICT', onupdate='CASCADE'), nullable=False)

    attribute = db.relationship('Attribute')


class SkillAdvanced(db.Model):
    __tablename__ = 'skill_advanced'

    prerequisite_level = db.Column(db.Numeric(3, 1), nullable=False, server_default=db.text("5.0"))
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'))
    base_skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'))

    base_skill = db.relationship('Skill', primaryjoin='SkillAdvanced.base_skill_id == Skill.id')
    skill = db.relationship('Skill', primaryjoin='SkillAdvanced.skill_id == Skill.id')


class SkillSpecialization(db.Model):
    __tablename__ = 'skill_specialization'

    name = db.Column(db.String(100), nullable=False)
    id = db.Column(pg.UUID, primary_key=True, server_default=db.text("uuid_generate_v4()"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'))

    skill = db.relationship('Skill')


class Starship(db.Model):
    __tablename__ = 'starship'

    starship_id = db.Column(db.Integer, primary_key=True, server_default=db.text("nextval('starship_starship_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    scale_id = db.Column(db.ForeignKey('scale.scale_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = db.Column(db.String(100), nullable=False)
    type = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    length = db.Column(db.Float(53), nullable=False)
    capacity_crew = db.Column(db.SmallInteger, nullable=False)
    capacity_passengers = db.Column(db.SmallInteger, nullable=False)
    capacity_troops = db.Column(db.SmallInteger, nullable=False)
    capacity_cargo = db.Column(db.SmallInteger, nullable=False)
    capacity_consumables = db.Column(db.SmallInteger, nullable=False)
    has_nav_computer = db.Column(db.SmallInteger, nullable=False)
    hyperdrive_multiplier = db.Column(db.Float(53), nullable=False)
    hyperdrive_backup = db.Column(db.Float(53), nullable=False)
    speed_space = db.Column(db.SmallInteger, nullable=False)
    speed_atmosphere_min = db.Column(db.SmallInteger, nullable=False)
    speed_atmosphere_max = db.Column(db.SmallInteger, nullable=False)
    maneuver_dice = db.Column(db.SmallInteger, nullable=False)
    maneuver_pip = db.Column(db.SmallInteger, nullable=False)
    hull_dice = db.Column(db.SmallInteger, nullable=False)
    hull_pip = db.Column(db.SmallInteger, nullable=False)
    shields_dice = db.Column(db.SmallInteger, nullable=False)
    shields_pip = db.Column(db.SmallInteger, nullable=False)
    sensors_passive_range = db.Column(db.SmallInteger, nullable=False)
    sensors_passive_dice = db.Column(db.SmallInteger, nullable=False)
    sensors_passive_pip = db.Column(db.SmallInteger, nullable=False)
    sensors_scan_range = db.Column(db.SmallInteger, nullable=False)
    sensors_scan_dice = db.Column(db.SmallInteger, nullable=False)
    sensors_scan_pip = db.Column(db.SmallInteger, nullable=False)
    sensors_search_range = db.Column(db.SmallInteger, nullable=False)
    sensors_search_dice = db.Column(db.SmallInteger, nullable=False)
    sensors_search_pip = db.Column(db.SmallInteger, nullable=False)
    sensors_focus_range = db.Column(db.SmallInteger, nullable=False)
    sensors_focus_dice = db.Column(db.SmallInteger, nullable=False)
    sensors_focus_pip = db.Column(db.SmallInteger, nullable=False)
    availability = db.Column(db.Enum('Common', 'Rare', 'Not For Sale', name='starship_availability'), nullable=False, server_default=db.text("'Common'::starship_availability"))
    price_new = db.Column(db.Integer)
    price_used = db.Column(db.Integer)

    scale = db.relationship('Scale')
    skill = db.relationship('Skill')


class StarshipWeapon(db.Model):
    __tablename__ = 'starship_weapon'

    starship_weapon_id = db.Column(db.BigInteger, primary_key=True, server_default=db.text("nextval('starship_weapon_starship_weapon_id_seq'::regclass)"))
    starship_id = db.Column(db.ForeignKey('starship.starship_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    type = db.Column(db.String(100), nullable=False)
    number = db.Column(db.SmallInteger, nullable=False)
    crew = db.Column(db.SmallInteger, nullable=False)
    fire_rate = db.Column(db.Float(53))
    fire_control_dice = db.Column(db.SmallInteger, nullable=False)
    fire_control_pip = db.Column(db.SmallInteger, nullable=False)
    fire_arc = db.Column(pg.ARRAY(pg.ENUM('Above', 'Below', 'Front', 'Back', 'Left', 'Right', name='starship_weapon_fire_arc')), nullable=False)
    fire_linked = db.Column(db.SmallInteger, nullable=False)
    range_minimum_space = db.Column(db.SmallInteger, nullable=False)
    range_short_space = db.Column(db.SmallInteger, nullable=False)
    range_medium_space = db.Column(db.SmallInteger, nullable=False)
    range_long_space = db.Column(db.SmallInteger, nullable=False)
    range_minimum_atmosphere = db.Column(db.SmallInteger, nullable=False)
    range_short_atmosphere = db.Column(db.SmallInteger, nullable=False)
    range_medium_atmosphere = db.Column(db.SmallInteger, nullable=False)
    range_long_atmosphere = db.Column(db.SmallInteger, nullable=False)
    damage_dice = db.Column(db.SmallInteger, nullable=False)
    damage_pip = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')
    starship = db.relationship('Starship')


class Vehicle(db.Model):
    __tablename__ = 'vehicle'

    vehicle_id = db.Column(db.Integer, primary_key=True, server_default=db.text("nextval('vehicle_vehicle_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    scale_id = db.Column(db.ForeignKey('scale.scale_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = db.Column(db.String(100), nullable=False)
    type = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    cover = db.Column(db.Float(53), nullable=False)
    capacity_crew = db.Column(db.SmallInteger, nullable=False)
    capacity_passengers = db.Column(db.SmallInteger, nullable=False)
    capacity_troops = db.Column(db.SmallInteger, nullable=False)
    capacity_cargo = db.Column(db.SmallInteger, nullable=False)
    capacity_consumables = db.Column(db.SmallInteger, nullable=False)
    speed_min = db.Column(db.SmallInteger, nullable=False)
    speed_max = db.Column(db.SmallInteger, nullable=False)
    altitude_min = db.Column(db.SmallInteger, nullable=False)
    altitude_max = db.Column(db.SmallInteger, nullable=False)
    maneuver_dice = db.Column(db.SmallInteger, nullable=False)
    maneuver_pip = db.Column(db.SmallInteger, nullable=False)
    hull_dice = db.Column(db.SmallInteger, nullable=False)
    hull_pip = db.Column(db.SmallInteger, nullable=False)
    shields_dice = db.Column(db.SmallInteger, nullable=False)
    shields_pip = db.Column(db.SmallInteger, nullable=False)
    availability = db.Column(db.Enum('Common', 'Rare', 'Not For Sale', name='vehicle_availability'), nullable=False, server_default=db.text("'Common'::vehicle_availability"))
    price_new = db.Column(db.Integer)
    price_used = db.Column(db.Integer)

    scale = db.relationship('Scale')
    skill = db.relationship('Skill')


class VehicleWeapon(db.Model):
    __tablename__ = 'vehicle_weapon'

    vehicle_weapon_id = db.Column(db.BigInteger, primary_key=True, server_default=db.text("nextval('vehicle_weapon_vehicle_weapon_id_seq'::regclass)"))
    vehicle_id = db.Column(db.ForeignKey('vehicle.vehicle_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    type = db.Column(db.String(100), nullable=False)
    number = db.Column(db.SmallInteger, nullable=False)
    crew = db.Column(db.SmallInteger, nullable=False)
    fire_rate = db.Column(db.Float(53))
    fire_control_dice = db.Column(db.SmallInteger, nullable=False)
    fire_control_pip = db.Column(db.SmallInteger, nullable=False)
    fire_arc = db.Column(pg.ARRAY(pg.ENUM('Above', 'Below', 'Front', 'Back', 'Left', 'Right', name='vehicle_weapon_fire_arc')), nullable=False)
    fire_linked = db.Column(db.SmallInteger, nullable=False)
    range_minimum = db.Column(db.SmallInteger, nullable=False)
    range_short = db.Column(db.SmallInteger, nullable=False)
    range_medium = db.Column(db.SmallInteger, nullable=False)
    range_long = db.Column(db.SmallInteger, nullable=False)
    damage_dice = db.Column(db.SmallInteger, nullable=False)
    damage_pip = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')
    vehicle = db.relationship('Vehicle')


class WeaponExplosive(db.Model):
    __tablename__ = 'weapon_explosive'

    explosive_id = db.Column(db.Integer, primary_key=True, server_default=db.text("nextval('weapon_explosive_explosive_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    range_minimum = db.Column(db.SmallInteger, nullable=False)
    range_short = db.Column(db.SmallInteger, nullable=False)
    range_medium = db.Column(db.SmallInteger, nullable=False)
    range_long = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')


t_weapon_explosive_damage = db.Table(
    'weapon_explosive_damage', db.metadata,
    db.Column('explosive_id', db.ForeignKey('weapon_explosive.explosive_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('radius', db.SmallInteger, nullable=False),
    db.Column('damage_dice', db.SmallInteger, nullable=False),
    db.Column('damage_pip', db.SmallInteger, nullable=False)
)


class WeaponMelee(db.Model):
    __tablename__ = 'weapon_melee'

    melee_id = db.Column(db.Integer, primary_key=True, server_default=db.text("nextval('weapon_melee_melee_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    damage_dice = db.Column(db.SmallInteger, nullable=False)
    damage_pip = db.Column(db.SmallInteger, nullable=False)
    max_damage_dice = db.Column(db.SmallInteger, nullable=False)
    max_damage_pip = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')


class WeaponRanged(db.Model):
    __tablename__ = 'weapon_ranged'

    ranged_id = db.Column(db.Integer, primary_key=True, server_default=db.text("nextval('weapon_ranged_ranged_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.id', ondelete='RESTRICT', onupdate='CASCADE'), index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    fire_rate = db.Column(db.Float(53))
    range_minimum = db.Column(db.SmallInteger, nullable=False)
    range_short = db.Column(db.SmallInteger, nullable=False)
    range_medium = db.Column(db.SmallInteger, nullable=False)
    range_long = db.Column(db.SmallInteger, nullable=False)
    damage_dice = db.Column(db.SmallInteger, nullable=False)
    damage_pip = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')
