

import re
import getpass

upattren = r"^[a-zA-Z]+[a-zA-Z0-9._-]*@[a-zA-Z]+\.[a-zA-Z]{2,}$"
ppattren = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,16}$"

def checkuser(mail):
  if re.match(upattren, mail):
    return True
  else:
    return False

def checkpw(pwd):
  if re.match(ppattren, pwd):
    return True
  else:
    return False

def register():
  mail = input('Enter the user mail id: ')
  if checkuser(mail):
    while True:
        pwd = getpass.getpass('Enter the password: ')
        if checkpw(pwd) and 6 <= len(pwd) <= 16 :
            pwd_confirm = getpass.getpass('Confirm password: ')
            if pwd == pwd_confirm:
                break
            else:
                print("Passwords do not match. Please try again.")
        else:
            print("Invalid password. Password must be between 6 and 16 characters and meet the complexity requirements.")

    try:
        with open('user_credentials.txt', 'a') as f:
          f.write(f"{mail}:{pwd}\n")
        print("User registered successfully!")
    except Exception as e:
        print(f"An error occurred: {e}")
  else:
    print("Invalid email. Please try again.")


def forgot_password():
    mail = input("Enter your registered email: ")
    if not checkuser(mail):
        print("Invalid email.")
        return

    try:
        with open('user_credentials.txt', 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print("User credentials file not found.")
        return

    found = False
    for i, line in enumerate(lines):
        u, p = line.strip().split(':')
        if u == mail:
            found = True
            while True:
                new_pwd = getpass.getpass("Enter new password: ")
                if checkpw(new_pwd) and 6 <= len(new_pwd) <= 16:
                    new_pwd_confirm = getpass.getpass("Confirm new password: ")
                    if new_pwd == new_pwd_confirm:
                        lines[i] = f"{u}:{new_pwd}\n"
                        with open('user_credentials.txt', 'w') as f:
                            f.writelines(lines)
                        print("Password updated successfully!")
                        break
                    else:
                        print("Passwords do not match. Please try again.")
                else:
                    print("Invalid password. Password must be between 6 and 16 characters and meet the complexity requirements.")

            break  # Exit the loop after updating password

    if not found:
        print("Email not found in the system.")


def login():
    mail = input("Enter your email: ")
    while True:
        pwd = getpass.getpass("Enter your password: ")
        try:
            with open('user_credentials.txt', 'r') as f:
                for line in f:
                    u, p = line.strip().split(':')
                    if u == mail and p == pwd:
                        print("Login successful!")
                        return True
                print("Invalid email or password. Please try again.")
                choice = int(input('''\n
                1.Do you want to register?:\n
                2.Enter if you forgot password
                3.previous menu '''))
                if choice ==1:
                    register()
                    return False # Indicate that registration was done, need another login attempt
                elif choice ==2:
                  forgot_password()
                  return False
                elif choice ==3:
                  return False
                else:
                    print("Invalid choice. Returning to login")

        except FileNotFoundError:
            print("User credentials file not found. Please register.")
            register()
            return False
        except Exception as e:
            print(f"An error occurred: {e}")






if __name__ == "__main__":


    try:
        while True:
            print(''' \nPlease select an option \n
                1. Register
                2. Login
                3. Forget Password
                ''')
            option = int(input())
            if option == 1:
                register()
            elif option == 2:
                login()
            elif option == 3:
                forgot_password()
            else:
                print("Invalid option")
    except:
        print("An exception occurred")
