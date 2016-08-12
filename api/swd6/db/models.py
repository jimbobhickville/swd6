import flask_sqlalchemy
from sqlalchemy.dialects import postgresql as pg
from sqlalchemy.ext.declarative import declarative_base

db = flask_sqlalchemy.SQLAlchemy()


class Ability(db.Model):
    __tablename__ = 'ability'

    id = db.Column('ability_id', db.Integer, primary_key=True, server_default=db.text("nextval('ability_ability_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = db.Column(db.String(100), nullable=False)
    difficulty = db.Column(db.Text, nullable=False)
    time_required = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)

    skill = db.relationship('Skill')
    prerequisites = db.relationship(
        'Ability',
        secondary='ability_prerequisite',
        primaryjoin='Ability.id == ability_prerequisite.c.ability_id',
        secondaryjoin='Ability.id == ability_prerequisite.c.prereq_ability_id'
    )


t_ability_prerequisite = db.Table(
    'ability_prerequisite',
    db.Column('ability_id', db.ForeignKey('ability.ability_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('prereq_ability_id', db.ForeignKey('ability.ability_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class Armor(db.Model):
    __tablename__ = 'armor'

    id = db.Column('armor_id', db.Integer, primary_key=True, server_default=db.text("nextval('armor_armor_id_seq'::regclass)"))
    areas_covered = db.Column(pg.ARRAY(db.Enum('Head', 'Neck', 'Upper Chest', 'Abdomen', 'Groin', 'Upper Back', 'Lower Back', 'Buttocks', 'Shoulders', 'Upper Arms', 'Forearms', 'Hands', 'Thighs', 'Shins', 'Feet', 'Joints', name='armor_areas_covered')), nullable=False)
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


class Attribute(db.Model):
    __tablename__ = 'attribute'

    id = db.Column('attrib_id', db.Integer, primary_key=True, server_default=db.text("nextval('attribute_attrib_id_seq'::regclass)"))
    name = db.Column(db.String(30), nullable=False)
    abbreviation = db.Column(db.String(3), nullable=False)
    description = db.Column(db.Text, nullable=False)
    has_level = db.Column(db.SmallInteger, nullable=False, index=True, server_default=db.text("'1'::smallint"))


t_character_armor = db.Table(
    'character_armor',
    db.Column('character_id', db.ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('armor_id', db.ForeignKey('armor.armor_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class CharacterSheet(db.Model):
    __tablename__ = 'character_sheet'

    character_id = db.Column(db.BigInteger, primary_key=True, server_default=db.text("nextval('character_sheet_character_id_seq'::regclass)"))
    race_id = db.Column(db.ForeignKey('race.race_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    planet_id = db.Column(db.ForeignKey('planet.planet_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    character_type_id = db.Column(db.ForeignKey('character_type.character_type_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    is_template = db.Column(db.SmallInteger, nullable=False, index=True, server_default=db.text("'0'::smallint"))
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    background = db.Column(db.Text, nullable=False)
    motivation = db.Column(db.Text, nullable=False)
    quote = db.Column(db.Text, nullable=False)
    gender = db.Column(db.Enum('M', 'F', name='character_sheet_gender'), nullable=False, server_default=db.text("'M'::character_sheet_gender"))
    age = db.Column(db.SmallInteger, nullable=False)
    height = db.Column(db.Float(53), nullable=False)
    weight = db.Column(db.SmallInteger, nullable=False)
    move_land = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'10'::smallint"))
    move_water = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    move_air = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    force_pts = db.Column(db.SmallInteger, nullable=False)
    dark_side_pts = db.Column(db.SmallInteger, nullable=False)
    character_pts = db.Column(db.SmallInteger, nullable=False)
    credits_owned = db.Column(db.BigInteger, nullable=False)
    credits_debt = db.Column(db.BigInteger, nullable=False)

    character_type = db.relationship('CharacterType')
    planet = db.relationship('Planet')
    race = db.relationship('Race')
    ranged_weapons = db.relationship('WeaponRanged', secondary='character_weapon_ranged')
    starships = db.relationship('Starship', secondary='character_starship')
    melee_weapons = db.relationship('WeaponMelee', secondary='character_weapon_melee')
    explosives = db.relationship('WeaponExplosive', secondary='character_weapon_explosive')
    vehicles = db.relationship('Vehicle', secondary='character_vehicle')


t_character_skill_level = db.Table(
    'character_skill_level',
    db.Column('character_id', db.ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('attrib_id', db.ForeignKey('attribute.attrib_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('skill_id', db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True),
    db.Column('specialize_id', db.ForeignKey('skill_specialization.specialize_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True),
    db.Column('skill_dice', db.SmallInteger, nullable=False),
    db.Column('skill_pip', db.SmallInteger, nullable=False)
)


t_character_starship = db.Table(
    'character_starship',
    db.Column('character_id', db.ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('starship_id', db.ForeignKey('starship.starship_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class CharacterType(db.Model):
    __tablename__ = 'character_type'

    id = db.Column('character_type_id', db.Integer, primary_key=True, server_default=db.text("nextval('character_type_character_type_id_seq'::regclass)"))
    name = db.Column(db.String(50), nullable=False)


t_character_vehicle = db.Table(
    'character_vehicle',
    db.Column('character_id', db.ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('vehicle_id', db.ForeignKey('vehicle.vehicle_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_explosive = db.Table(
    'character_weapon_explosive',
    db.Column('character_id', db.ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('explosive_id', db.ForeignKey('weapon_explosive.explosive_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_melee = db.Table(
    'character_weapon_melee',
    db.Column('character_id', db.ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('melee_id', db.ForeignKey('weapon_melee.melee_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


t_character_weapon_ranged = db.Table(
    'character_weapon_ranged',
    db.Column('character_id', db.ForeignKey('character_sheet.character_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('ranged_id', db.ForeignKey('weapon_ranged.ranged_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
)


class Image(db.Model):
    __tablename__ = 'image'

    image_id = db.Column(db.BigInteger, primary_key=True, server_default=db.text("nextval('image_image_id_seq'::regclass)"))
    mod_name = db.Column(db.String(40), nullable=False, index=True)
    id = db.Column(db.BigInteger, nullable=False, index=True)
    order_num = db.Column(db.SmallInteger, nullable=False)
    name = db.Column(db.String(120), nullable=False)
    dir = db.Column(db.String(100), nullable=False)
    caption = db.Column(db.String(200), nullable=False)
    image_width = db.Column(db.SmallInteger, nullable=False)
    image_height = db.Column(db.SmallInteger, nullable=False)
    thumb_width = db.Column(db.SmallInteger, nullable=False)
    thumb_height = db.Column(db.SmallInteger, nullable=False)


class Modifier(db.Model):
    __tablename__ = 'modifier'

    modifier_id = db.Column(db.BigInteger, primary_key=True, server_default=db.text("nextval('modifier_modifier_id_seq'::regclass)"))
    mod_name = db.Column(db.String(40), nullable=False, index=True)
    id = db.Column(db.BigInteger, nullable=False, index=True)
    attrib_id = db.Column(db.ForeignKey('attribute.attrib_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    specialize_id = db.Column(db.ForeignKey('skill_specialization.specialize_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    modifier_dice = db.Column(db.SmallInteger, nullable=False)
    modifier_pip = db.Column(db.SmallInteger, nullable=False)
    conditions = db.Column(db.Text, nullable=False)

    attribute = db.relationship('Attribute')
    skill = db.relationship('Skill')
    specialize = db.relationship('SkillSpecialization')


class Planet(db.Model):
    __tablename__ = 'planet'

    id = db.Column('planet_id', db.Integer, primary_key=True, server_default=db.text("nextval('planet_planet_id_seq'::regclass)"))
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)


class Race(db.Model):
    __tablename__ = 'race'

    id = db.Column('race_id', db.Integer, primary_key=True, server_default=db.text("nextval('race_race_id_seq'::regclass)"))
    planet_id = db.Column(db.ForeignKey('planet.planet_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    playable_type = db.Column(db.Enum('PC', 'NPC', 'Creature', name='race_playable_type'), nullable=False, index=True, server_default=db.text("'PC'::race_playable_type"))
    name = db.Column(db.String(100), nullable=False)
    basic_ability = db.Column(db.Enum('Speak', 'Understand', 'None', name='race_basic_ability'), nullable=False, server_default=db.text("'Speak'::race_basic_ability"))
    description = db.Column(db.Text, nullable=False)
    special_abilities = db.Column(db.Text, nullable=False)
    story_factors = db.Column(db.Text, nullable=False)
    attribute_dice = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'12'::smallint"))
    attribute_pip = db.Column(db.SmallInteger, nullable=False)
    min_move_land = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'10'::smallint"))
    max_move_land = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'12'::smallint"))
    min_move_water = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'5'::smallint"))
    max_move_water = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'6'::smallint"))
    min_move_air = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    max_move_air = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))
    min_height = db.Column(db.Float(53), nullable=False, server_default=db.text("'1.5'::double precision"))
    max_height = db.Column(db.Float(53), nullable=False, server_default=db.text("'2'::double precision"))

    planet = db.relationship('Planet')


t_race_attrib_levels = db.Table(
    'race_attrib_levels',
    db.Column('race_id', db.ForeignKey('race.race_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('attrib_id', db.ForeignKey('attribute.attrib_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('min_dice', db.SmallInteger, nullable=False, server_default=db.text("'2'::smallint")),
    db.Column('min_pip', db.SmallInteger, nullable=False),
    db.Column('max_dice', db.SmallInteger, nullable=False, server_default=db.text("'4'::smallint")),
    db.Column('max_pip', db.SmallInteger, nullable=False),
    db.Index('idx_16565_race_id_2', 'race_id', 'attrib_id', unique=True)
)


class Scale(db.Model):
    __tablename__ = 'scale'

    id = db.Column('scale_id', db.Integer, primary_key=True, server_default=db.text("nextval('scale_scale_id_seq'::regclass)"))
    name = db.Column(db.String(30), nullable=False)
    scale_dice = db.Column(db.SmallInteger, nullable=False)
    scale_pip = db.Column(db.SmallInteger, nullable=False)


class Skill(db.Model):
    __tablename__ = 'skill'

    id = db.Column('skill_id', db.Integer, primary_key=True, server_default=db.text("nextval('skill_skill_id_seq'::regclass)"))
    attrib_id = db.Column(db.ForeignKey('attribute.attrib_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    has_specializations = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'1'::smallint"))
    has_abilities = db.Column(db.SmallInteger, nullable=False, server_default=db.text("'0'::smallint"))

    attribute = db.relationship('Attribute')


t_skill_advanced = db.Table(
    'skill_advanced',
    db.Column('skill_id', db.ForeignKey('skill.skill_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('base_skill_id', db.ForeignKey('skill.skill_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('prereq_dice', db.SmallInteger, nullable=False),
    db.Column('prereq_pip', db.SmallInteger, nullable=False)
)


class SkillSpecialization(db.Model):
    __tablename__ = 'skill_specialization'

    id = db.Column('specialize_id', db.Integer, primary_key=True, server_default=db.text("nextval('skill_specialization_specialize_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True)
    name = db.Column(db.String(100), nullable=False)

    skill = db.relationship('Skill')


class Starship(db.Model):
    __tablename__ = 'starship'

    id = db.Column('starship_id', db.Integer, primary_key=True, server_default=db.text("nextval('starship_starship_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
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
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    type = db.Column(db.String(100), nullable=False)
    number = db.Column(db.SmallInteger, nullable=False)
    crew = db.Column(db.SmallInteger, nullable=False)
    fire_rate = db.Column(db.Float(53))
    fire_control_dice = db.Column(db.SmallInteger, nullable=False)
    fire_control_pip = db.Column(db.SmallInteger, nullable=False)
    fire_arc = db.Column(pg.ARRAY(db.Enum('Above', 'Below', 'Front', 'Back', 'Left', 'Right', name='starship_weapon_fire_arc')), nullable=False)
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

    id = db.Column('vehicle_id', db.Integer, primary_key=True, server_default=db.text("nextval('vehicle_vehicle_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
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
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    type = db.Column(db.String(100), nullable=False)
    number = db.Column(db.SmallInteger, nullable=False)
    crew = db.Column(db.SmallInteger, nullable=False)
    fire_rate = db.Column(db.Float(53))
    fire_control_dice = db.Column(db.SmallInteger, nullable=False)
    fire_control_pip = db.Column(db.SmallInteger, nullable=False)
    fire_arc = db.Column(pg.ARRAY(db.Enum('Above', 'Below', 'Front', 'Back', 'Left', 'Right', name='vehicle_weapon_fire_arc')), nullable=False)
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

    id = db.Column('explosive_id', db.Integer, primary_key=True, server_default=db.text("nextval('weapon_explosive_explosive_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    range_minimum = db.Column(db.SmallInteger, nullable=False)
    range_short = db.Column(db.SmallInteger, nullable=False)
    range_medium = db.Column(db.SmallInteger, nullable=False)
    range_long = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')


t_weapon_explosive_damage = db.Table(
    'weapon_explosive_damage',
    db.Column('explosive_id', db.ForeignKey('weapon_explosive.explosive_id', ondelete='CASCADE', onupdate='RESTRICT'), nullable=False, index=True),
    db.Column('radius', db.SmallInteger, nullable=False),
    db.Column('damage_dice', db.SmallInteger, nullable=False),
    db.Column('damage_pip', db.SmallInteger, nullable=False)
)


class WeaponMelee(db.Model):
    __tablename__ = 'weapon_melee'

    id = db.Column('melee_id', db.Integer, primary_key=True, server_default=db.text("nextval('weapon_melee_melee_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    damage_dice = db.Column(db.SmallInteger, nullable=False)
    damage_pip = db.Column(db.SmallInteger, nullable=False)
    max_damage_dice = db.Column(db.SmallInteger, nullable=False)
    max_damage_pip = db.Column(db.SmallInteger, nullable=False)

    skill = db.relationship('Skill')


class WeaponRanged(db.Model):
    __tablename__ = 'weapon_ranged'

    id = db.Column('ranged_id', db.Integer, primary_key=True, server_default=db.text("nextval('weapon_ranged_ranged_id_seq'::regclass)"))
    skill_id = db.Column(db.ForeignKey('skill.skill_id', ondelete='SET NULL', onupdate='RESTRICT'), index=True)
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