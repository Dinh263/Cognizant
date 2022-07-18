from faker import Faker
import time
import datetime
import random
from models.hero import WorkingClassHero
import os


fker = Faker()


def generate_a_random_working_hero():
    """
    This function will generate a random person which: birthday, name, gender, natid, salary, tax.
    :return: a working class hero
    """
    birthday = generate_random_birthday_date()
    name = fker.name()
    gender = random.choice(['M', 'F'])
    natid = generate_random_email(name)
    salary = str(random.randint(3000, 50000))
    tax = str(generate_random_tax_pay_on_salary(salary))
    person = WorkingClassHero()
    person.set_birthday(birthday)
    person.set_gender(gender)
    person.set_name(name)
    person.set_natid(natid)
    person.set_salary(salary)
    person.set_tax(tax)
    return person


def generate_random_list_working_class_hero(nber_of_heros: int)-> list:
    list_hero = []
    for i in range(nber_of_heros):
        person = generate_a_random_working_hero()
        list_hero.append(person)
    return list_hero


def generate_random_birthday_date() -> str:
    month = str(random.randint(1, 12))
    if len(month) == 1:
        month = "0" + month
    year = str(random.randint(1950, 2000))
    day = str(random.randint(10, 28))
    if len(day) == 1:
        day = "0" + day
    return day + month + year


def get_current_epoch_time() -> str:
    return str(int(time.time()))


def generate_random_email(name: str) -> str:
    """
    This function is used for generate random email base on name
    first, if name has 2 words and has space or "." we will replace space and "." by "_". Example name="John doe" then it wil be name="John_doe"
    second, we will get epochotime, it is a unique number
    third, we will generate random company email
    Then final, we will combine name+epchotime+email
    :param name: name of working hero class
    :return: email
    """
    if ' ' in name:
        name = name.replace(' ', '_')
    if '.' in name:
        name = name.replace('.', '_')
    cur_time = get_current_epoch_time()
    company_email = fker.company_email()
    arr = company_email.split('@')
    return f'{name}{cur_time}@{arr[1]}'


def generate_random_tax_pay_on_salary(salary) -> int:
    """
    This function is used for genereate random tax base on salary
    :param salary: salary of working hero class
    :return: tax amount pay.
    """
    salary = int(salary)
    if salary < 4000:
        tax_percent = 0
    elif salary >= 4000 and salary < 10000:
        tax_percent = 10
    elif salary >= 10000 and salary < 20000:
        tax_percent = 20
    else:
        tax_percent = 30
    tax = int(tax_percent * salary / 100)
    return tax


def get_index_of_string(parent_str: str, sub_str: str) -> int:
    """
    this function is used for search substring in parent string
    :param parent_str: parent string
    :param sub_str: search string
    :return: index of found search string
    """
    return parent_str.index(sub_str)


def write_data_to_csv_file(location, file_name, list_data_person):
    """
    This function is used for write data to csv file
    :param location: location of file csv
    :param file_name: the file name of csv
    :param list_data_person: list data working class here we will insert to csv
    :return: None
    """
    header = ['natid', 'name', 'gender', 'salary', 'birthday', 'tax']
    data = []
    for person in list_data_person:
        list = []
        list.append(person.natid)
        list.append(person.name)
        list.append(person.gender)
        list.append(person.salary)
        list.append(person.birthday)
        list.append(person.tax)
        data.append(list)
    file_path = os.path.join(location, file_name)
    print(data)
    with open(file_path, 'w') as file:
        for header in header:
            file.write(str(header)+',')
        file.write('\n')
        for row in data:
            print(row)
            for x in row:
                file.write(str(x)+',')
            file.write('\n')


def get_age_base_on_bithday(day, month, year) -> int:
    """
    This function will calculate your age.
    :param day: day of your birthday
    :param month: month of your birthday
    :param year: year of your birthday
    :return: your age.
    """
    birthdate = datetime.date(int(year), int(month), int(day))
    today = datetime.date.today()
    return today.year - birthdate.year - ((today.month, today.day) < (birthdate.month, birthdate.day))


def calculate_tax_relief_base_on_salary_tax_variable_gender_bonus(salary, tax_paid, variable, gender_bonus):
    """
    This function is used for calculate tax relief amount
    :param salary: of working class hero
    :param tax_paid: of working class hero
    :param variable: check function variable
    :param gender_bonus: addition bonus base on gender
    :return: tax relief amount
    """
    tax_relief = round((float(salary) - float(tax_paid)) * float(variable) + float(gender_bonus), 2)
    if tax_relief < 50:
        tax_relief = 50
    return "{:.2f}".format(tax_relief)


def reformat_natid_field_with_dolar(natid):
    """This function is used for reformat the natid, natid will be keep the same 4 first chars, the rest of chars will be set to $.
    Example your natid = "john.riel@gmail.com" then after reformat it will be "john$$$$$$$$$$$$$$$"
    """
    str_len = len(natid)
    fstr = natid[0:4]
    format_str = fstr.ljust(str_len, "$")
    return format_str