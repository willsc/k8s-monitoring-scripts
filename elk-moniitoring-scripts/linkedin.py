#!/usr/local/bin/python3

# function to login to linkedin
def login():
    driver = webdriver.Chrome()
    driver.get("https://www.linkedin.com")
    driver.find_element_by_id("session_key").send_keys("email")
    driver.find_element_by_id("session_password").send_keys("password")
    driver.find_element_by_class_name("sign-in-form__submit-button").click()
    return driver   

# function to query linkedin for a list of companies and job titles using list of companies in a csv file and return query results

def query(driver, company, job_title):
    driver.get("https://www.linkedin.com/jobs/search/?keywords="+company+"%20"+job_title+"&location=United%20States&locationId=us%3A0&geoId=101165590&trk=public_jobs_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0")
    time.sleep(5)
    return driver


# function to read csv file and return a list of companies and job roles

def read_csv():
    with open('companies.csv', newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        companies = []
        for row in reader:
            companies.append(row)
    return companies

# function that uses the query function to query linkedin for each company and job title in the list of companies and job titles and return a list of query results

def query_all(driver, companies):
    results = []
    for company in companies:
        results.append(query(driver, company[0], company[1]))
    return results

# function to parse the query results and return a list of people and their companies and job titles

def parse_results(results):
    parsed_results = []
    for result in results:
        people = result.find_elements_by_class_name("job-card-container__link-wrapper")
        for person in people:
            parsed_results.append(person.text)
    return parsed_results


# function to write the list of job titles, companies, and people to a csv file

def write_csv(parsed_results):
    with open('results.csv', 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')
        for result in parsed_results:
            writer.writerow([result])





# function to send message to people in the list of job titles, companies, and people

def send_message(driver, parsed_results):
    for result in parsed_results:
        for person in result.split(""):
            if "people" in person:
                driver.get(person.split(" ")[-1])
                time.sleep(5)
                driver.find_element_by_class_name("pv-s-profile-actions").find_element_by_tag_name("button").click()
                time.sleep(5)
                driver.find_element_by_class_name("msg-form__contenteditable").send_keys("Hi, I noticed you work at " + person.split(" ")[0] + " and I am interested in a position at your company. I have attached my resume. Please let me know if you have any questions or if you would like to schedule an interview. Thanks!")
                time.sleep(5)
                driver.find_element_by_class_name("msg-form__send-button").click()
                time.sleep(5)


# main function to run the script



def main():
    driver = login()
    companies = read_csv()
    results = query_all(driver, companies)
    parsed_results = parse_results(results)
    write_csv(parsed_results)
    send_message(driver, parsed_results)



if __name__ == "__main__":


















