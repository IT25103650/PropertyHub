import java.io.*;
import java.util.*;

public class FileUtil {

    // 1. CREATE: Appends a single line to a file (Used for Registering, Posting a Car, etc.)
    public static void appendData(String fileName, String data) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(fileName, true))) {
            writer.write(data);
            writer.newLine();
        } catch (IOException e) {
            System.err.println("Error writing to " + fileName + ": " + e.getMessage());
        }
    }

    // 2. READ: Returns all lines as a List (Used for Login checks and showing the Car Gallery)
    public static List<String> readData(String fileName) {
        List<String> lines = new ArrayList<>();
        File file = new File(fileName);
        if (!file.exists()) return lines; // Return empty list if file doesn't exist yet

        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException e) {
            System.err.println("Error reading " + fileName + ": " + e.getMessage());
        }
        return lines;
    }

    // 3. OVERWRITE: Replaces file content (Used for Updating prices or Deleting a user)
    public static void overwriteFile(String fileName, List<String> allData) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(fileName, false))) {
            for (String line : allData) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error overwriting " + fileName + ": " + e.getMessage());
        }
    }
}
